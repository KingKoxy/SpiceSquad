import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';

import '../models/group.dart';

class GroupService extends AsyncNotifier<List<Group>> {
  @override
  FutureOr<List<Group>> build() {
    return ref.watch(groupRepositoryProvider).fetchAllGroupsForUser();
  }
}
