import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:printing/printing.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/services/recipe_service.dart";

///Screen to display the pdf of an Recipe
class PdfRecipeViewPage extends StatelessWidget {
  /// The route name of this screen.
  static const routeName = "/pdf-recipe-page";

  /// The recipe to display.
  final Recipe _recipe;

  /// Constructs a new pdf recipe page.
  const PdfRecipeViewPage({required Recipe recipe, super.key}) : _recipe = recipe;

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pdfRecipeViewHeadline(_recipe.title),
        ),
      ),
      body: Consumer(
        builder: (context, ref, _) => PdfPreview(
          maxPageWidth: 700,
          onPrinted: _showPrintedToast,
          onShared: _showSharedToast,
          build: (format) =>
              _exportRecipe(ref.read(recipeServiceProvider.notifier), AppLocalizations.of(context)!, format),
        ),
      ),
    );
  }

  void _showPrintedToast(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.pdfSaveSuccess)),
    );
  }

  void _showSharedToast(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.pdfShareSuccess)),
    );
  }

  FutureOr<Uint8List> _exportRecipe(
    RecipeService recipeService,
    AppLocalizations appLocalizations,
    final PdfPageFormat format,
  ) {
    return recipeService.exportRecipe(_recipe, appLocalizations);
  }
}
