import "dart:math";

import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/repository_providers.dart";

/// Widget to select the name for an ingredient and shows suggestions
class IngredientNameInput extends ConsumerStatefulWidget {
  /// The controller that contains the currently selected name
  final TextEditingController _controller;

  /// Creates a new ingredient name input widget
  const IngredientNameInput({required TextEditingController controller, super.key}) : _controller = controller;

  @override
  ConsumerState<IngredientNameInput> createState() => _IngredientNameInputState();
}

class _IngredientNameInputState extends ConsumerState<IngredientNameInput> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: const Key("ingredientNameInput"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.ingredientNameEmptyError;
            }
            if (value.length > 32) {
              return AppLocalizations.of(context)!.ingredientTooLongError;
            }
            return null;
          },
          controller: widget._controller,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.ingredientNameInputLabel),
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        //Shows the suggestions
        FutureBuilder(
          future: ref.watch(ingredientDataRepository).fetchIngredientNames(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Search for matches and show in grid
              final List<String> filteredNames =
                  snapshot.data!.where((element) => element.toLowerCase().contains(_searchText.toLowerCase())).toList();
              filteredNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 40,
                  crossAxisCount: 3,
                ),
                itemCount: min(filteredNames.length, 12),
                itemBuilder: (context, index) {
                  return GridTile(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.zero,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          widget._controller.text = filteredNames[index];
                          setState(() {
                            _searchText = filteredNames[index];
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          child: AutoSizeText(
                            filteredNames[index],
                            minFontSize: 8,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
