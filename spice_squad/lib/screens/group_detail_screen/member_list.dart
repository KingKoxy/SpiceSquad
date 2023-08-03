import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:share_plus/share_plus.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/models/group_member.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/add_button.dart";
import "package:spice_squad/widgets/approval_dialog.dart";

/// Widget to display a list of [GroupMember]s
class MemberList extends ConsumerWidget {
  /// Whether or not the user is admin and can access admin actions
  final bool _isAdmin;

  /// The group the members belong to
  final Group _group;

  /// The id of the current user
  final String _userId;

  /// A callback to refetch the members
  final VoidCallback _refetch;

  /// Creates a [MemberList]
  const MemberList({
    required String userId,
    required Group group,
    required bool isAdmin,
    required void Function() refetch,
    super.key,
  })  : _refetch = refetch,
        _userId = userId,
        _group = group,
        _isAdmin = isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<GroupMember> members = _group.members;
    // Sorts the members alphabetically so that the current user is always at the top, followed by the admins, followed by the rest
    members.sort((a, b) {
      if (a.id == _userId && b.id != _userId) return -1;
      if (a.id != _userId && b.id == _userId) return 1;
      if (a.isAdmin && !b.isAdmin) return -1;
      if (!a.isAdmin && b.isAdmin) return 1;
      return a.userName.toLowerCase().compareTo(b.userName.toLowerCase());
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.memberListHeadline,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AddButton(
              onPressed: () {
                Share.share(
                  AppLocalizations.of(context)!.groupCodeShareMessage(_group.name, _group.groupCode),
                  subject: AppLocalizations.of(context)!.groupCodeShareSubject,
                );
              },
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: member.profileImage != null
                              ? CircleAvatar(
                                  foregroundImage: MemoryImage(member.profileImage!),
                                )
                              : CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                  child: Text(
                                    member.userName.substring(0, 1),
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              member.userName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (member.isAdmin)
                              Text(
                                AppLocalizations.of(context)!.administrator,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (member.id != _userId && _isAdmin)
                      PopupMenuButton(
                        tooltip: "",
                        splashRadius: 24,
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            member.isAdmin
                                ? PopupMenuItem(
                                    onTap: () => _removeAdminStatus(ref.read(groupServiceProvider.notifier), member),
                                    child: Text(AppLocalizations.of(context)!.adminActionRemoveAdmin),
                                  )
                                : PopupMenuItem(
                                    onTap: () => _makeAdmin(ref.read(groupServiceProvider.notifier), member),
                                    child: Text(AppLocalizations.of(context)!.adminActionMakeAdmin),
                                  ),
                            PopupMenuItem(
                              onTap: () => _kickUser(context, ref.read(groupServiceProvider.notifier), member),
                              child: Text(AppLocalizations.of(context)!.adminActionKick),
                            ),
                            PopupMenuItem<void>(
                              onTap: () => _banUser(context, ref.read(groupServiceProvider.notifier), member),
                              child: Text(AppLocalizations.of(context)!.adminActionBan),
                            ),
                          ];
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Future<void> _removeAdminStatus(GroupService groupService, GroupMember member) {
    return groupService.removeAdminStatus(member.id, _group.id).then((value) => _refetch());
  }

  Future<void> _makeAdmin(GroupService groupService, GroupMember member) {
    return groupService.makeAdmin(member.id, _group.id).then((value) => _refetch());
  }

  Future<void> _kickUser(BuildContext context, GroupService groupService, GroupMember member) {
    return Future.delayed(
      Duration.zero,
      () => showDialog(
        context: context,
        builder: (context) => ApprovalDialog(
          title: AppLocalizations.of(context)!.kickingApprovalTitle,
          message: AppLocalizations.of(context)!.kickingApprovalMessage(member.userName),
          onApproval: () {
            Navigator.of(context).pop();
            groupService.kickUser(member.id, _group.id).then((value) => _refetch());
          },
        ),
      ),
    );
  }

  Future<void> _banUser(BuildContext context, GroupService groupService, GroupMember member) async {
    return Future.delayed(
      Duration.zero,
      () => showDialog(
        context: context,
        builder: (context) {
          return ApprovalDialog(
            title: AppLocalizations.of(context)!.banningApprovalTitle,
            message: AppLocalizations.of(context)!.banningApprovalMessage(member.userName),
            onApproval: () {
              Navigator.of(context).pop();
              groupService.banUser(member.id, _group.id).then((value) => _refetch());
            },
          );
        },
      ),
    );
  }
}
