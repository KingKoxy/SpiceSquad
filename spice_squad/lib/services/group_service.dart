import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';

import '../models/group.dart';
import '../models/recipe.dart';

class GroupService extends AsyncNotifier<List<Group>> {
  @override
  FutureOr<List<Group>> build() {
    return ref.watch(groupRepositoryProvider).fetchAllGroupsForUser();
  }

  Future<Group> getGroupById(String groupId) {
    return ref.watch(groupRepositoryProvider).fetchGroupById(groupId);
  }

  Future<void> joinGroup(String groupCode) {
    //TODO: implement group joining
    throw UnimplementedError();
  }

  Future<void> createGroup(String title) {
    //TODO: implement group creation
    throw UnimplementedError();
  }

  Future<void> deleteGroup(String groupId) {
    //TODO: implement group deletion
    throw UnimplementedError();
  }

  Future<void> leaveGroup(String groupId) {
    //TODO: implement group leaving
    throw UnimplementedError();
  }

  Future<void> setGroupName(String groupId, String value) {
    //TODO: implement group renaming
    throw UnimplementedError();
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
}
