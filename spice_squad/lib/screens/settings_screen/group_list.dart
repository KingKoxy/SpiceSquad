import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/group_detail_screen/group_detail_screen.dart";
import "package:spice_squad/screens/group_joining_screen.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/add_button.dart";
import "package:spice_squad/widgets/remove_button.dart";

/// Widget for displaying a list of groups the user is a member of
class GroupList extends ConsumerWidget {
  /// Creates a new group list
  const GroupList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              "Squads",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AddButton(
              onPressed: () {
                Navigator.pushNamed(context, GroupJoiningScreen.routeName);
              },
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // Fetch groups from database
        ref.watch(groupServiceProvider).when(
          data: (groups) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: groups.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).pushNamed(GroupDetailScreen.routeName, arguments: groups[index].id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  groups[index].name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                RemoveButton(
                                  onPressed: () {
                                    _leaveGroup(context, ref.read(groupServiceProvider.notifier), groups[index].id);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Bisher bist du kein Mitglied einer Squad",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                      ),
                    ),
            );
          },
          error: (error, stackTrace) {
            return Text(error.toString());
          },
          loading: () {
            return const CircularProgressIndicator();
          },
        )
      ],
    );
  }

  void _leaveGroup(BuildContext context, GroupService groupService, String groupId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Gruppe verlassen"),
          content: const Text("Bist du sicher, dass du die Gruppe verlassen möchtest?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Abbrechen"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                groupService.leaveGroup(groupId);
              },
              child: const Text("Ich bin mir sicher"),
            )
          ],
        );
      },
    );
  }
}
