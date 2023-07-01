import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:share_plus/share_plus.dart";
import "package:spice_squad/models/group_member.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/widgets/add_button.dart";

/// Widget to display a list of [GroupMember]s
class MemberList extends ConsumerWidget {
  /// The list of [GroupMember]s to display
  final List<GroupMember> members;

  /// Whether or not the user is admin and can access admin actions
  final bool isAdmin;

  /// The code of the group the members belong to
  final String groupCode;

  /// Creates a [MemberList]
  const MemberList({required this.groupCode, required this.members, required this.isAdmin, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = ref.read(userRepositoryProvider).getUserId()!;

    // Sorts the members alphabetically so that the current user is always at the top, followed by the admins, followed by the rest
    members.sort((a, b) {
      if (a.id == userId && b.id != userId) return -1;
      if (a.id != userId && b.id == userId) return 1;
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
              "Mitglieder",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AddButton(
              onPressed: () {
                Share.share(
                  "Tritt jetzt meiner SpiceSquad bei. Gib dazu einfach diesen Code in der App ein: $groupCode",
                  subject: "Tritt meiner SpiceSquad bei!",
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
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                              ? const CircleAvatar(
                                  foregroundImage: AssetImage("assets/icons/exampleRecipeImage.jpeg"),
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
                                "Administrator",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                              ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        //TODO: implement popup for admin actions
                      },
                      icon: const ImageIcon(
                        AssetImage("assets/icons/dots.png"),
                      ),
                      splashRadius: 24,
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
