import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';
import 'package:spice_squad/providers/service_providers.dart';
import 'package:spice_squad/screens/qr_code_screen.dart';
import 'package:spice_squad/services/group_service.dart';
import 'group_recipe_list.dart';
import 'member_list.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  static const routeName = '/group-detail';

  const GroupDetailScreen({super.key});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final groupId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Squad"),
      ),
      body: Center(
          child: FutureBuilder(
        future: ref.watch(groupServiceProvider.notifier).getGroupById(groupId),
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
                              AssetImage("assets/icons/pen2.png"),
                              color: Colors.white,
                            )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(QRCodeScreen.routeName, arguments: group);
                            },
                            icon: const ImageIcon(
                              AssetImage("assets/icons/qr_code.png"),
                              size: 48,
                            )),
                        IconButton(
                            onPressed: () {
                              _leaveGroup(ref.read(groupServiceProvider.notifier), group.id);
                            },
                            icon: const ImageIcon(
                              AssetImage("assets/icons/logout.png"),
                              size: 48,
                            )),
                      ],
                    ),
                    TextButton(
                        onPressed: () => _deleteGroup(context, ref.read(groupServiceProvider.notifier), group.id),
                        child: const Text("Gruppe auflösen")),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MemberList(members: group.members, isAdmin: isAdmin),
                const SizedBox(
                  height: 20,
                ),
                GroupRecipeList(
                  recipes: group.recipes,
                  isAdmin: isAdmin,
                  groupId: groupId,
                )
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }

  void _renameGroup(BuildContext context, GroupService groupService, String oldName, String groupId) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();
    controller.text = oldName;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Umbenennen"),
            content: Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(fillColor: Theme.of(context).colorScheme.onSurfaceVariant),
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bitte gib einen neuen Gruppennamen ein.";
                  }
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Abbrechen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Speichern"),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    groupService.setGroupName(groupId, controller.text);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  void _leaveGroup(GroupService groupService, String groupId) {
    groupService.leaveGroup(groupId);
  }

  void _deleteGroup(BuildContext context, GroupService groupService, String groupId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Gruppe auflösen"),
            content: const Text("Bist du dir wirklich sicher? Es gibt danach keinen Weg zurück"),
            actions: <Widget>[
              TextButton(
                child: const Text("Abbrechen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Ich bin mir sicher"),
                onPressed: () {
                  groupService.deleteGroup(groupId);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
