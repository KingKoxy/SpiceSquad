import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/models/group_member.dart";
import "package:spice_squad/models/group_recipe.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/providers/service_providers.dart";

/// Service that handles all group related logic.
///
/// Every method sets the [state] to update optimistically or indicate loading while executing
class GroupService extends AsyncNotifier<List<Group>> {
  @override
  FutureOr<List<Group>> build() {
    return ref.watch(groupRepositoryProvider).fetchAllGroupsForUser();
  }

  /// Fetches the group with the given [groupId].
  Future<Group> getGroupById(String groupId) {
    return ref.watch(groupRepositoryProvider).fetchGroupById(groupId);
  }

  /// Makes the user join the group with the given [groupCode].
  Future<void> joinGroup(String groupCode) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).joinGroup(groupCode).whenComplete(() {
      refetch();
      ref.read(recipeServiceProvider.notifier).refetch();
    });
  }

  /// Creates a new group with the given [name].
  Future<void> createGroup(String name) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).createGroup(name).whenComplete(() {
      refetch();
      ref.read(recipeServiceProvider.notifier).refetch();
    });
  }

  /// Deletes the group with the given [groupId].
  Future<void> deleteGroup(String groupId) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).deleteGroup(groupId).whenComplete(() {
      refetch();
      ref.read(recipeServiceProvider.notifier).refetch();
    });
  }

  /// Makes the user leave the group with the given [groupId].
  Future<void> leaveGroup(String groupId) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).leaveGroup(groupId).whenComplete(() {
      refetch();
      ref.read(recipeServiceProvider.notifier).refetch();
    });
  }

  /// Updates the name of the group with the given [groupId] with the given [value].
  Future<void> setGroupName(String groupId, String value) {
    print("rename group");
    final Group updatedGroup = _updateSingleGroup(
      groupId,
      (oldGroup) => Group(
        id: oldGroup.id,
        name: value,
        groupCode: oldGroup.groupCode,
        members: oldGroup.members,
        recipes: oldGroup.recipes,
      ),
    );
    return ref.read(groupRepositoryProvider).updateGroup(updatedGroup).whenComplete(refetch);
  }

  /// Makes the user with the given [userId] admin of the group with the given [groupId]
  Future<void> makeAdmin(String userId, String groupId) {
    _updateSingleGroup(groupId, (Group oldGroup) {
      final List<GroupMember> updatedMemberList = oldGroup.members;
      final int oldMemberIndex = updatedMemberList.indexWhere((member) => member.id == userId);
      final GroupMember oldMember = updatedMemberList.removeAt(oldMemberIndex);
      final GroupMember newMember = GroupMember(user: oldMember, isAdmin: true);
      updatedMemberList.insert(oldMemberIndex, newMember);
      return Group(
        id: oldGroup.id,
        name: oldGroup.name,
        groupCode: oldGroup.groupCode,
        members: updatedMemberList,
        recipes: oldGroup.recipes,
      );
    });
    return ref.read(adminRepositoryProvider).makeAdmin(userId, groupId).whenComplete(refetch);
  }

  /// Removes the admin status of the user with the given [userId] in the group with the [groupId]
  Future<void> removeAdminStatus(String userId, String groupId) {
    _updateSingleGroup(groupId, (Group oldGroup) {
      final List<GroupMember> updatedMemberList = oldGroup.members;
      final int oldMemberIndex = updatedMemberList.indexWhere((member) => member.id == userId);
      final GroupMember oldMember = updatedMemberList.removeAt(oldMemberIndex);
      final GroupMember newMember = GroupMember(user: oldMember, isAdmin: false);
      updatedMemberList.insert(oldMemberIndex, newMember);
      return Group(
        id: oldGroup.id,
        name: oldGroup.name,
        groupCode: oldGroup.groupCode,
        members: updatedMemberList,
        recipes: oldGroup.recipes,
      );
    });
    return ref.read(adminRepositoryProvider).removeAdminStatus(userId, groupId).whenComplete(refetch);
  }

  /// Kicks the user with the given [userId] from the group with the given [groupId]
  Future<void> kickUser(String userId, String groupId) {
    _updateSingleGroup(groupId, (Group oldGroup) {
      final List<GroupMember> updatedMemberList = oldGroup.members;
      updatedMemberList.removeWhere((member) => member.id == userId);
      return Group(
        id: oldGroup.id,
        name: oldGroup.name,
        groupCode: oldGroup.groupCode,
        members: updatedMemberList,
        recipes: oldGroup.recipes,
      );
    });
    return ref.read(adminRepositoryProvider).kickUser(userId, groupId).whenComplete(refetch);
  }

  /// Bans the user with the given [userId] from the group with the given [groupId]
  Future<void> banUser(String userId, String groupId) {
    _updateSingleGroup(groupId, (Group oldGroup) {
      final List<GroupMember> updatedMemberList = oldGroup.members;
      updatedMemberList.removeWhere((member) => member.id == userId);
      return Group(
        id: oldGroup.id,
        name: oldGroup.name,
        groupCode: oldGroup.groupCode,
        members: updatedMemberList,
        recipes: oldGroup.recipes,
      );
    });
    return ref.read(adminRepositoryProvider).banUser(userId, groupId).whenComplete(refetch);
  }

  /// Toggles the censoring status of the [recipe] in the group with the given [groupId]
  Future<void> toggleCensoring(GroupRecipe recipe, String groupId) {
    _updateSingleGroup(groupId, (Group oldGroup) {
      final List<GroupRecipe> updatedRecipeList = oldGroup.recipes;
      final int oldRecipeIndex = updatedRecipeList.indexWhere((element) => element.id == recipe.id);
      final GroupRecipe oldRecipe = updatedRecipeList.removeAt(oldRecipeIndex);
      final GroupRecipe newRecipe = GroupRecipe(recipe: oldRecipe, isCensored: !recipe.isCensored);
      updatedRecipeList.insert(oldRecipeIndex, newRecipe);
      return Group(
        id: oldGroup.id,
        name: oldGroup.name,
        groupCode: oldGroup.groupCode,
        members: oldGroup.members,
        recipes: updatedRecipeList,
      );
    });
    return ref.read(adminRepositoryProvider).setCensored(recipe.id, groupId, !recipe.isCensored).whenComplete(() async {
      await refetch();
      await ref.read(recipeServiceProvider.notifier).refetch();
    });
  }

  /// Fetches all groups for the current user and sets the state to [AsyncData] with the fetched groups.
  FutureOr<void> refetch() {
    ref.read(groupRepositoryProvider).fetchAllGroupsForUser().then((value) {
      state = AsyncData(value);
    }).catchError((e) {
      state = AsyncError(e, StackTrace.current);
    });
  }

  /// Updates the group with the given [groupId] with the given [updatingFunction] in the [state] and returns the updated group.
  Group _updateSingleGroup(String groupId, Group Function(Group oldGroup) updatingFunction) {
    if (state.valueOrNull == null) throw Exception("state not set");
    final List<Group> list = state.value!;
    final int oldGroupIndex = list.indexWhere((group) => group.id == groupId);
    final Group oldGroup = list.removeAt(oldGroupIndex);
    final Group newGroup = updatingFunction(oldGroup);
    list.insert(oldGroupIndex, newGroup);
    state = AsyncData(list);
    return newGroup;
  }
}
