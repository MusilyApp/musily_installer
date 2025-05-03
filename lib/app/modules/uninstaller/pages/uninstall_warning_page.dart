import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musily_installer/generated/app_localizations.dart';
import '../uninstaller_controller.dart';

class UninstallWarningPage extends StatelessWidget {
  const UninstallWarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GetBuilder<UninstallerController>(
      builder: (controller) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  l10n.warningUninstall,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.warningUninstallMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: controller.acceptedUninstall,
                      onChanged: (value) =>
                          controller.setAcceptedUninstall(value ?? false),
                    ),
                    Text(l10n.uninstallConfirmation),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: controller.removeAppData,
                      onChanged: (value) =>
                          controller.setRemoveAppData(value ?? true),
                    ),
                    Text(l10n.removeAppData),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
