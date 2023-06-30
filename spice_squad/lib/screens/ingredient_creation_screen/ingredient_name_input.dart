import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';

class IngredientNameInput extends ConsumerStatefulWidget {
  final TextEditingController controller;

  const IngredientNameInput({required this.controller, super.key});

  @override
  ConsumerState<IngredientNameInput> createState() => _IngredientNameInputState();
}

class _IngredientNameInputState extends ConsumerState<IngredientNameInput> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) return "Gib bitte einen Namen ein";
          return null;
        },
        controller: widget.controller,
        decoration: const InputDecoration(hintText: "Zutat"),
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });
        },
      ),
      const SizedBox(
        height: 16,
      ),
      FutureBuilder(
          future: ref.watch(ingredientNameRepositoryProvider).fetchIngredientNames(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<String> filteredNames =
                  snapshot.data!.where((element) => element.toLowerCase().contains(_searchText.toLowerCase())).toList();
              return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 40, crossAxisCount: 3),
                  itemCount: min(filteredNames.length, 12),
                  itemBuilder: (context, index) {
                    return GridTile(
                      child: InkWell(
                        onTap: () {
                          widget.controller.text = filteredNames[index];
                          setState(() {
                            _searchText = filteredNames[index];
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
                          //TODO: Make text match size of gridtile
                          child: Text(filteredNames[index], style: Theme.of(context).textTheme.titleSmall,),
                        ),
                      ),
                    );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          }),
    ]);
  }
}
