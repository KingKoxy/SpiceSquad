import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spice_squad/models/group.dart';

class QRCodeScreen extends StatelessWidget {
  static const routeName = '/qr-code';

  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Group group = ModalRoute.of(context)!.settings.arguments as Group;

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR-Code"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      group.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text("Squad", style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey)),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: QrImageView(
                        data: group.groupCode,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                        dataModuleStyle:
                            const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 300,
              child: Text(
                "Wenn du diesen QR-Code mit jemandem teilst, kann diese Person ihn in der App scannen, um dieser Squad beizutreten.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
