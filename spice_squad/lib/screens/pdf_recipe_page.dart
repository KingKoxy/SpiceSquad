import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:open_file/open_file.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:printing/printing.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";

///Screen to display the pdf of an Recipe
class PdfRecipeViewPage extends ConsumerStatefulWidget {
  /// The route name of this screen.
  static const routeName = "/pdf-recipe-page";

  /// The recipe to display.
  final Recipe recipe;

  /// Constructs a new pdf recipe page.
  const PdfRecipeViewPage({required this.recipe, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PdfRecipeViewPageState();
}

class _PdfRecipeViewPageState extends ConsumerState<PdfRecipeViewPage> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      PdfPreviewAction(icon: const Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .pdfRecipeViewHeadline(widget.recipe.title),
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: exportRecipe,
      ),
    );
  }

  Future<void> saveAsFile(
    final BuildContext context,
    final LayoutCallback build,
    final PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);
    final file = File("assets/tipps.pdf");
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  void showPrintedToast(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.pdfSaveSuccess)),
    );
  }

  void showSharedToast(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.pdfShareSuccess)),
    );
  }

  FutureOr<Uint8List> exportRecipe(final PdfPageFormat format) {
    return ref.read(recipeServiceProvider.notifier).exportRecipe(widget.recipe, AppLocalizations.of(context)!);
  }
}
