import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";

/// Screen for scanning a QR-Code
///
/// This screen is used to scan a QR-Code with the camera.
///
/// The QR-Code is scanned using the [MobileScanner] widget from the [mobile_scanner](https://pub.dev/packages/mobile_scanner) package.
///
/// The scanned QR-Code is returned to the previous screen.
class QRScannerScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = "/qr-scanner";

  /// Creates a new QR-Code scanner screen
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupCodeRegex = RegExp(r"\d{4}-\d{4}");
    return Scaffold(
      appBar: AppBar(title: const Text("QR-Code scannen")),
      body: MobileScanner(
        // fit: BoxFit.contain,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null && code.isNotEmpty) {
              if (groupCodeRegex.hasMatch(code)) {
                Navigator.of(context).pop(code);
              }
            }
          }
        },
      ),
    );
  }
}
