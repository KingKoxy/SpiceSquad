import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/models/group_member.dart';
import 'package:spice_squad/providers/repository_providers.dart';
import 'package:spice_squad/models/group.dart';
import 'package:spice_squad/models/group_recipe.dart';

class GroupService extends AsyncNotifier<List<Group>> {
  @override
  FutureOr<List<Group>> build() {
    return ref.watch(groupRepositoryProvider).fetchAllGroupsForUser();
  }

  Future<Group> getGroupById(String groupId) {
    return ref.watch(groupRepositoryProvider).fetchGroupById(groupId);
  }

  Future<void> joinGroup(String groupCode) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).joinGroup(groupCode).then((value) => _refetch());
  }

  Future<void> createGroup(String name) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).createGroup(name).then((value) => _refetch());
  }

  Future<void> deleteGroup(String groupId) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).deleteGroup(groupId).then((value) => _refetch());
  }

  Future<void> leaveGroup(String groupId) {
    state = const AsyncLoading();
    return ref.read(groupRepositoryProvider).leaveGroup(groupId).then((value) => _refetch());
  }

  Future<void> setGroupName(String groupId, String value) {
    final Group updatedGroup = _updateSingleGroup(
        groupId,
        (oldGroup) => Group(
            id: oldGroup.id,
            name: value,
            groupCode: oldGroup.groupCode,
            members: oldGroup.members,
            recipes: oldGroup.recipes));
    return ref.read(groupRepositoryProvider).updateGroup(updatedGroup).then((value) => _refetch());
  }

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
          recipes: oldGroup.recipes);
    });
    return ref.read(adminRepositoryProvider).makeAdmin(userId, groupId).then((value) => _refetch());
  }

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
          recipes: oldGroup.recipes);
    });
    return ref.read(adminRepositoryProvider).removeAdminStatus(userId, groupId).then((value) => _refetch());
  }

  Future<void> kickUser(String userId, String groupId) {
    _updateSingleGroup(groupId, (Group oldGroup) {
      final List<GroupMember> updatedMemberList = oldGroup.members;
      updatedMemberList.removeWhere((member) => member.id == userId);
      return Group(
          id: oldGroup.id,
          name: oldGroup.name,
          groupCode: oldGroup.groupCode,
          members: updatedMemberList,
          recipes: oldGroup.recipes);
    });
    return ref.read(adminRepositoryProvider).kickUser(userId, groupId).then((value) => _refetch());
  }

  Future<void> banUser(String userId, String groupId) {
    _updateSingleGroup(groupId, (Group oldGroup) {
      final List<GroupMember> updatedMemberList = oldGroup.members;
      updatedMemberList.removeWhere((member) => member.id == userId);
      return Group(
          id: oldGroup.id,
          name: oldGroup.name,
          groupCode: oldGroup.groupCode,
          members: updatedMemberList,
          recipes: oldGroup.recipes);
    });
    return ref.read(adminRepositoryProvider).banUser(userId, groupId).then((value) => _refetch());
  }

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
          recipes: updatedRecipeList);
    });
    return ref
        .read(adminRepositoryProvider)
        .setCensored(recipe.id, groupId, !recipe.isCensored)
        .then((value) => _refetch());
  }

  Future<void> _refetch() {
    return ref.read(groupRepositoryProvider).fetchAllGroupsForUser().then((value) => state = AsyncData(value));
  }

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
