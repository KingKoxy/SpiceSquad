import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";

class QRScannerScreen extends StatelessWidget {
  static const routeName = "/qr-scanner";

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
