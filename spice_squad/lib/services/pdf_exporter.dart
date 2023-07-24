import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:spice_squad/models/recipe.dart";

/// Service that handles all PDF export related logic.
class PDFExporter {
  /// Exports the given [recipe] as a PDF and shares it.
  static Future<Uint8List> exportRecipe(
    final Recipe recipe,
    final AppLocalizations appLocalizations,
  ) async {
    final recipeImage = recipe.image;
    final logo = (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();
    final pdf = pw.Document(
      title: "${recipe.title}_spice_squad",
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Container(
          alignment: pw.Alignment.topLeft,
          padding: const pw.EdgeInsets.only(bottom: 3.0),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                width: 0.5,
                color: PdfColor.fromInt(0xFFFF4170),
              ),
            ),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(
                pw.MemoryImage(logo),
                width: 50,
                height: 50,
                fit: pw.BoxFit.cover,
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 50,
                  width: 200,
                  padding: const pw.EdgeInsets.only(left: 20),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(
                    "SpiceSquad",
                    style: pw.TextStyle(
                      color: const PdfColor(0, 0, 0, 0.5),
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  children: [
                    _buildInstructions(context, recipe, appLocalizations),
                    _buildInfo(context, recipe, appLocalizations),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 0,
                child: pw.Container(
                  padding: const pw.EdgeInsets.only(left: 16.0, top: 16.0),
                  alignment: pw.Alignment.topLeft,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      _buildInfoSideCard(
                        context,
                        recipeImage,
                        recipe,
                        appLocalizations,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildTable(
    pw.Context context,
    Recipe recipe,
    AppLocalizations appLocalizations,
  ) {
    final ingredients = recipe.ingredients;

    final data = ingredients.map((ingredient) {
      return [
        "${ingredient.amount.toStringAsFixed(2)} ${ingredient.unit}",
        ingredient.name,
      ];
    }).toList();

    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.TableHelper.fromTextArray(
        border: null,
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: PdfColor.fromInt(0xFFFF4170),
              width: .5,
            ),
          ),
        ),
        rowDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: PdfColor.fromInt(0xFFFF4170),
              width: .5,
            ),
          ),
        ),
        cellAlignment: pw.Alignment.centerLeft,
        cellHeight: 20,
        cellAlignments: {
          0: pw.Alignment.centerRight,
          1: pw.Alignment.centerLeft,
        },
        data: data,
      ),
    );
  }

  static pw.Widget _buildInfoSideCard(
    pw.Context context,
    Uint8List? image,
    Recipe recipe,
    AppLocalizations appLocalizations,
  ) {
    return pw.Container(
      alignment: pw.Alignment.topLeft,
      padding: const pw.EdgeInsets.only(bottom: 3.0),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (image != null)
            pw.Container(
              width: 150,
              height: 100,
              child: pw.FittedBox(
                fit: pw.BoxFit.cover,
                child: pw.Image(
                  pw.MemoryImage(
                    image,
                  ),
                ),
              ),
            ),
          pw.Container(
            alignment: pw.Alignment.topLeft,
            padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  appLocalizations.defaultPortions(recipe.defaultPortionAmount),
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ),
          _buildTable(context, recipe, appLocalizations),
          pw.Container(
            alignment: pw.Alignment.bottomRight,
            padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  appLocalizations.recipeAuthor(recipe.author.userName),
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInstructions(
    pw.Context context,
    Recipe recipe,
    AppLocalizations appLocalizations,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          alignment: pw.Alignment.topLeft,
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: pw.Column(
            children: [
              pw.Text(
                recipe.title,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                textScaleFactor: 1.5,
              ),
            ],
          ),
        ),
        pw.Text(
          recipe.instructions,
          textAlign: pw.TextAlign.left,
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                width: 0.5,
                color: PdfColor.fromInt(0xFFFF4170),
              ),
            ),
          ),
        )
      ],
    );
  }

  static pw.Widget _buildInfo(
    pw.Context context,
    Recipe recipe,
    AppLocalizations appLocalizations,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 130,
                child: pw.Text(
                  appLocalizations.totalTime,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(appLocalizations.duration(recipe.duration)),
            ],
          ),
          pw.SizedBox(
            height: 8,
          ),
          pw.Row(
            children: [
              pw.Container(
                width: 130,
                child: pw.Text(
                  appLocalizations.difficulty,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text("${recipe.difficulty}"),
            ],
          ),
          pw.SizedBox(
            height: 8,
          ),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 130,
                child: pw.Text(
                  appLocalizations.labels,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                _createLabelsString(recipe, appLocalizations),
              )
            ],
          ),
          pw.SizedBox(
            height: 8,
          ),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  width: 0.5,
                  color: PdfColor.fromInt(0xFFFF4170),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static String _createLabelsString(
    Recipe recipe,
    AppLocalizations appLocalizations,
  ) {
    const separator = "\n";
    final buffer = StringBuffer();
    final List<String> strings = [];
    if (recipe.isVegetarian) {
      strings.add(appLocalizations.labelVegetarian);
    }
    if (recipe.isVegan) {
      strings.add(appLocalizations.labelVegan);
    }
    if (recipe.isKosher) {
      strings.add(appLocalizations.labelKosher);
    }
    if (recipe.isGlutenFree) {
      strings.add(appLocalizations.labelGlutenFree);
    }
    if (recipe.isHalal) {
      strings.add(appLocalizations.labelHalal);
    }
    buffer.writeAll(strings, separator);
    return buffer.toString();
  }
}
