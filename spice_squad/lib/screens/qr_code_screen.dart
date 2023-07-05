import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:spice_squad/models/group.dart";

/// Screen for displaying a QR-Code for joining a group
///
/// This screen is used to display a QR-Code for joining a group.
///
/// The QR-Code is generated using the [QrImageView] widget from the [qr_flutter](https://pub.dev/packages/qr_flutter) package.
///
/// The group is obtained from the route arguments.
class QRCodeScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = "/qr-code";

  /// Creates a new QR-Code screen
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Group group = ModalRoute.of(context)!.settings.arguments as Group;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.qrCodeHeadline),
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
                    Text(AppLocalizations.of(context)!.qrCodeSquadLabel,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),),
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
                AppLocalizations.of(context)!.qrCodeInstructions,
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
