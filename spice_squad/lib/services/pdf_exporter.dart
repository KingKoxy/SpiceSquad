import "dart:io";
import "dart:typed_data";
import "package:path_provider/path_provider.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:share_plus/share_plus.dart";
import "package:spice_squad/models/recipe.dart";

class PDFExporter {
  static Future<void> exportRecipe(Recipe recipe) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
            pw.Text(recipe.title),
            pw.Text("von ${recipe.author.userName}"),
            if (recipe.image != null) pw.Image(pw.MemoryImage(recipe.image!)),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("Zutaten für ${recipe.defaultPortionAmount} Portionen:"),
              pw.Table(
                columnWidths: {0: const pw.IntrinsicColumnWidth(), 1: const pw.FlexColumnWidth()},
                children: recipe.ingredients
                    .map((ingredient) => pw.TableRow(children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text("${ingredient.amount} ${ingredient.unit}"),),
                          pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(ingredient.name))
                        ],),)
                    .toList(),
              ),
              pw.Text(recipe.instructions)
            ],)
          ],); // Center
        },),);

    final Directory directory = await getTemporaryDirectory();
    final Uint8List bytes = await pdf.save();
    final file = File("${directory.path}/${recipe.title}.pdf");
    await file.writeAsBytes(bytes);
    Share.shareXFiles([XFile(file.path)]);
  }
}
