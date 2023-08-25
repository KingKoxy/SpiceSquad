import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/group_detail_screen/group_detail_screen.dart";
import "package:spice_squad/screens/group_joining_screen.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/add_button.dart";
import "package:spice_squad/widgets/approval_dialog.dart";
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
              AppLocalizations.of(context)!.squadListLabel,
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
            groups.sort((Group a, Group b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
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
                            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    groups[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                RemoveButton(
                                  onPressed: () {
                                    _leaveGroup(context, ref.read(groupServiceProvider.notifier), groups[index]);
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
                        AppLocalizations.of(context)!.userNotInAnySquads,
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

  void _leaveGroup(BuildContext context, GroupService groupService, Group group) {
    showDialog(
      context: context,
      builder: (context) {
        return ApprovalDialog(
          title: AppLocalizations.of(context)!.leaveSquadDialogTitle,
          message: AppLocalizations.of(context)!.leaveSquadDialogDescription(group.name),
          onApproval: () {
            Navigator.of(context).pop();
            groupService.leaveGroup(group.id);
          },
        );
      },
    );
  }
}
