import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';
import 'package:spice_squad/models/group.dart';
import 'package:spice_squad/models/recipe.dart';

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
    if (state.valueOrNull == null) throw Exception();

    final List<Group> listCopy = state.value!;
    final int oldGroupIndex = listCopy.indexWhere((group) => group.id == groupId);
    final Group oldGroup = listCopy.removeAt(oldGroupIndex);
    final Group newGroup = Group(
        id: oldGroup.id,
        name: value,
        groupCode: oldGroup.groupCode,
        members: oldGroup.members,
        recipes: oldGroup.recipes);
    listCopy.insert(oldGroupIndex, newGroup);
    state = AsyncData(listCopy);
    return ref.read(groupRepositoryProvider).updateGroup(newGroup).then((value) => _refetch());
  }

  Future<void> makeAdmin(String userId, String groupId) {
    //TODO: implement admin making
    throw UnimplementedError();
  }

  Future<void> removeAdminStatus(String userId, String groupId) {
    //TODO: implement admin unmaking
    throw UnimplementedError();
  }

  Future<void> kickUser(String userId, String groupId) {
    //TODO: implement user kicking
    throw UnimplementedError();
  }

  Future<void> banUser(String userId, String groupCode) {
    //TODO: implement user banning
    throw UnimplementedError();
  }

  Future<void> toggleCensoring(Recipe recipe, String groupId) {
    //TODO: implement recipe censoring
    throw UnimplementedError();
  }

  Future<void> _refetch() {
    return ref.read(groupRepositoryProvider).fetchAllGroupsForUser().then((value) => state = AsyncData(value));
  }
}
