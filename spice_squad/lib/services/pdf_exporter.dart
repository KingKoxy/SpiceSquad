import "package:flutter/services.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:spice_squad/models/recipe.dart";

/// Service that handles all PDF export related logic.
class PDFExporter {
  /// Exports the given [recipe] as a PDF and shares it.
  static Future<Uint8List> exportRecipe(
    final Recipe recipe,
  ) async {
    final recipeImage =
        (await rootBundle.load("assets/images/exampleImage.jpeg"))
            .buffer
            .asUint8List();
    final logo =
        (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();
    final pdf = pw.Document(
      title: "${recipe.title}_spice_squad",
    );

    pdf.addPage(
      pw.MultiPage(
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
                    _buildInstructions(context, recipe),
                    _buildInfo(context, recipe),
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
                      _buildInfoSideCard(context, recipeImage, recipe),
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

  static pw.Widget _buildTable(pw.Context context, Recipe recipe) {
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
    Uint8List image,
    Recipe recipe,
  ) {
    return pw.Container(
      alignment: pw.Alignment.topLeft,
      padding: const pw.EdgeInsets.only(bottom: 3.0),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (recipe.image != null)
            pw.Container(
              width: 150,
              height: 100,
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.FittedBox(
                fit: pw.BoxFit.cover,
                child: pw.Image(
                  pw.MemoryImage(recipe.image!),
                  width: 150,
                  height: 100,
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
                  "Zutaten für ${recipe.defaultPortionAmount.toString()} Portionen:",
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ),
          _buildTable(context, recipe),
          pw.Container(
            alignment: pw.Alignment.bottomRight,
            padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  "Rezept von: ${recipe.author.userName}",
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInstructions(pw.Context context, Recipe recipe) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          alignment: pw.Alignment.topLeft,
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: pw.Column(
            //mainAxisAlignment: pw.MainAxisAlignment.start,
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

  static pw.Widget _buildInfo(pw.Context context, Recipe recipe) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 130,
                child: pw.Text(
                  "Zubereitunszeit",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text("${recipe.duration.toString()} min"),
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
                  "Schwierigkeitsgrad",
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
            children: [
              pw.Container(
                width: 130,
                child: pw.Text(
                  "Labels",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                _createLabelsString(recipe),
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

  static String _createLabelsString(Recipe recipe) {
    const separator = ", ";
    final buffer = StringBuffer();
    final List<String> strings = [];
    if (recipe.isVegetarian) {
      strings.add("Vegetarisch");
    }
    if (recipe.isVegan) {
      strings.add("Vegan");
    }
    if (recipe.isKosher) {
      strings.add("Koscher");
    }
    if (recipe.isGlutenFree) {
      strings.add("Gluten frei");
    }
    if (recipe.isHalal) {
      strings.add("Halal");
    }
    buffer.writeAll(strings, separator);
    return buffer.toString();
  }
}
