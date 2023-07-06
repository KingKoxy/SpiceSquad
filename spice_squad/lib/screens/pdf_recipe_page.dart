import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:open_file/open_file.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:printing/printing.dart";
import "package:spice_squad/models/recipe.dart";

///Screen to display the pdf of an Recipe
class PdfRecipePage extends StatefulWidget {
  /// The route name of this screen.
  static const routeName = "/pdf-recipe-page";

  /// The recipe to display.
  final Recipe recipe;

  late Uint8List logo;

  /// Constructs a new pdf recipe page.
  PdfRecipePage({required this.recipe, super.key});

  @override
  State<PdfRecipePage> createState() => _PdfRecipePageState();
}

class _PdfRecipePageState extends State<PdfRecipePage> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    widget.logo =
        (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF von ${widget.recipe.title}"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
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
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Speichern erfolgreich")));
  }

  void showSharedToast(final BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Teilen erfolgreich")));
  }

  Future<Uint8List> generatePdf(final PdfPageFormat format) async {
    final recipeImage =
        (await rootBundle.load("assets/images/exampleImage.jpeg"))
            .buffer
            .asUint8List();
    final pdf = pw.Document(
      title: "Flutter titel",
    );

    pdf.addPage(
      pw.MultiPage(
        header: _buildHeader,
        build: (context) => [
          pw.Row(
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  children: [
                    _buildInstructions(context),
                    _buildInfo(context),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 0,
                child: pw.Container(
                  padding: const pw.EdgeInsets.only(left: 16.0),
                  alignment: pw.Alignment.topLeft,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      _buildInfoSideCard(context, recipeImage),
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

  pw.Widget _buildTable(pw.Context context) {
    final ingredients = widget.recipe.ingredients;

    final data = ingredients.map((ingredient) {
      return [
        "${ingredient.amount.toStringAsFixed(2)} ${ingredient.unit}",
        ingredient.name,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      border: null,
      headerDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.red,
            width: .5,
          ),
        ),
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.red,
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
    );
  }

  pw.Widget _buildInfoSideCard(pw.Context context, Uint8List image) {
    return pw.Container(
      alignment: pw.Alignment.topLeft,
      padding: const pw.EdgeInsets.only(bottom: 3.0),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Container(
            width: 150,
            height: 100,
            decoration: pw.BoxDecoration(
              color: PdfColors.grey,
              borderRadius: pw.BorderRadius.circular(16),),
            child: pw.FittedBox(
              fit: pw.BoxFit.cover,
            child:pw.Image(
              pw.MemoryImage(image),
              width: 150,
              height: 100,
            ),),
          ),
          pw.Container(
            alignment: pw.Alignment.topLeft,
            padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Column(
              //mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  "Zutaten für ${widget.recipe.defaultPortionAmount.toString()} Portionen:",
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ),
          _buildTable(context),
          pw.Container(
            alignment: pw.Alignment.bottomRight,
            padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Column(
              //mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  "Rezept von: ${widget.recipe.author.userName}",
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      padding: const pw.EdgeInsets.only(bottom: 3.0),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 0.5, color: PdfColors.red),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Image(
            pw.MemoryImage(widget.logo),
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
                  color: PdfColor(0, 0, 0, 0.5),
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  pw.Widget _buildInstructions(pw.Context context) {
    return pw.Column(
      children: [
        pw.Container(
          alignment: pw.Alignment.topLeft,
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: pw.Column(
            //mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text(
                widget.recipe.title,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                textScaleFactor: 1.5,
              ),
            ],
          ),
        ),
        pw.Paragraph(
            text:
                "The Portable Document Format (PDF) is a file format developed by Adobe in the 1990s to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems. Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it. PDF was standardized as an open format, ISO 32000, in 2008, and no longer requires any royalties for its implementation."),
        pw.Container(
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(width: 0.5, color: PdfColors.red),
            ),
          ),
        )
      ],
    );
  }

  pw.Widget _buildInfo(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 16.0),
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
              pw.Text("${widget.recipe.duration.toString()} min"),
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
              pw.Text("${widget.recipe.difficulty}"),
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
                _createLabelsString(),
              )
            ],
          ),
          pw.SizedBox(
            height: 8,
          ),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 0.5, color: PdfColors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _createLabelsString() {
    const separator = ", ";
    final buffer = StringBuffer();
    final List<String> strings = [];
    if (widget.recipe.isVegetarian) {
      strings.add("Vegetarisch");
    }
    if (widget.recipe.isVegan) {
      strings.add("Vegan");
    }
    if (widget.recipe.isKosher) {
      strings.add("Koscher");
    }
    if (widget.recipe.isGlutenFree) {
      strings.add("Gluten frei");
    }
    if (widget.recipe.isHalal) {
      strings.add("Halal");
    }
    buffer.writeAll(strings, separator);
    return buffer.toString();
  }
}
