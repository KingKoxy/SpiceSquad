import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A widget that is used to indicate a divider between two other widgets that are in an "or" relationship.
class OrWidget extends StatelessWidget {
  /// Creates a new or widget.
  const OrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.or,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
