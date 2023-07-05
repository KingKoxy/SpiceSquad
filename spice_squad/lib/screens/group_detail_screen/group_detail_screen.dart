import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/group_detail_screen/group_recipe_list.dart";
import "package:spice_squad/screens/group_detail_screen/member_list.dart";
import "package:spice_squad/screens/qr_code_screen.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/approval_dialog.dart";
import "package:spice_squad/widgets/input_dialog.dart";

/// Screen to display the details of a group
///
/// The group is identified by the id passed as an argument to the route.
class GroupDetailScreen extends ConsumerStatefulWidget {
  /// The route name of this screen
  static const routeName = "/group-detail";

  /// The id of the group to display
  final String groupId;

  /// Creates a [GroupDetailScreen]
  const GroupDetailScreen({required this.groupId, super.key});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.groupDetailHeadline),
      ),
      body: Center(
        child: FutureBuilder(
          future: ref.watch(groupServiceProvider.notifier).getGroupById(widget.groupId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final group = snapshot.data!;
              final bool isAdmin = group.members
                  .any((element) => element.isAdmin && element.id == ref.read(userRepositoryProvider).getUserId());

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          _renameGroup(context, ref.read(groupServiceProvider.notifier), group.name, group.id);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                group.name,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
                              ),
                            ),
                            if (isAdmin)
                              const SizedBox(
                                width: 5,
                              ),
                            if (isAdmin)
                              const ImageIcon(
                                SpiceSquadIconImages.edit,
                                color: Colors.white,
                                size: 32,
                              )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 48,
                            splashRadius: 32,
                            onPressed: () {
                              Navigator.of(context).pushNamed(QRCodeScreen.routeName, arguments: group);
                            },
                            icon: const ImageIcon(
                              SpiceSquadIconImages.qrCode
                            ),
                          ),
                          IconButton(
                            iconSize: 48,
                            splashRadius: 32,
                            onPressed: () {
                              _leaveGroup(ref.read(groupServiceProvider.notifier), group);
                            },
                            icon: const ImageIcon(
                              SpiceSquadIconImages.leave,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => _deleteGroup(context, ref.read(groupServiceProvider.notifier), group),
                        child: Text(AppLocalizations.of(context)!.deleteSquadButton),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MemberList(
                    isAdmin: isAdmin,
                    group: group,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GroupRecipeList(
                    recipes: group.recipes,
                    isAdmin: isAdmin,
                    groupId: group.id,
                  )
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  /// Show a dialog to rename the group with the given [groupId]
  void _renameGroup(BuildContext context, GroupService groupService, String oldName, String groupId) {
    showDialog(
      context: context,
      builder: (context) {
        return InputDialog(
          title: AppLocalizations.of(context)!.renameDialogTitle,
          initialValue: oldName,
          onSave: (String value) {
            groupService.setGroupName(groupId, value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.squadNameEmptyError;
            }
            return null;
          },
        );
      },
    );
  }

  /// Leaves the given group
  void _leaveGroup(GroupService groupService, Group group) {
    showDialog(
      context: context,
      builder: (context) => ApprovalDialog(
        title: AppLocalizations.of(context)!.leaveSquadDialogTitle,
        message: AppLocalizations.of(context)!.leaveSquadDialogDescription(group.name),
        onApproval: () => groupService.leaveGroup(group.id),
      ),
    );
  }

  /// Shows a dialog to confirm the deletion of a group
  void _deleteGroup(BuildContext context, GroupService groupService, Group group) {
    showDialog(
      context: context,
      builder: (context) {
        return ApprovalDialog(
          title: AppLocalizations.of(context)!.deleteSquadDialogTitle,
          message: AppLocalizations.of(context)!.deleteSquadDialogDescription(group.name),
          onApproval: () {
            groupService.deleteGroup(group.id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
