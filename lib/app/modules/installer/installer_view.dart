import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musily_installer/app/widgets/ui/buttons/ly_filled_button.dart';
import 'package:musily_installer/generated/app_localizations.dart';
import 'installer_controller.dart';
import 'pages/welcome_page.dart';
import '../../widgets/dependencies_page.dart';
import 'pages/license_page.dart' as app_licenses_page;
import '../../widgets/progress_page.dart';
import '../../widgets/done_page.dart';

class InstallerView extends StatelessWidget {
  const InstallerView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GetBuilder<InstallerController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: controller.installing
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  onPageChanged: controller.setCurrentPage,
                  children: [
                    const WelcomePage(),
                    const app_licenses_page.LicensePage(),
                    DependenciesPage(
                      dependencies: controller.dependencies,
                      acceptedDependencies: controller.acceptedDependencies,
                      onAcceptDependencies: controller.setAcceptedDependencies,
                    ),
                    ProgressPage(
                      title: l10n.installationProgress,
                      progress: controller.installProgress,
                      status: controller.status,
                      terminalOutput: controller.terminalOutput,
                      showTerminalOutput: controller.showTerminalOutput,
                      onToggleTerminalOutput: controller.setShowTerminalOutput,
                      showCacheError: controller.cacheUpdateFailed,
                    ),
                    DonePage(
                      title: l10n.installationComplete,
                      message: l10n.installationCompleteMessage,
                      showRunOption: true,
                      runAfterFinish: controller.runAfterInstall,
                      onRunOptionChanged: controller.setRunAfterInstall,
                      showCacheError: controller.cacheUpdateFailed,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Builder(
                      builder: (context) {
                        if (controller.currentPage == 0) {
                          return LyFilledButton(
                            onPressed: () {
                              controller.setCurrentPage(1);
                            },
                            child: Text(l10n.next),
                          );
                        }
                        if (controller.currentPage == 1) {
                          return LyFilledButton(
                            onPressed: controller.acceptedLicense
                                ? () {
                                    controller.setCurrentPage(2);
                                  }
                                : null,
                            child: Text(l10n.next),
                          );
                        }
                        if (controller.currentPage == 2) {
                          return LyFilledButton(
                            onPressed: controller.acceptedDependencies ||
                                    !controller.hasMissingDependencies()
                                ? () {
                                    controller.setCurrentPage(3);
                                    controller.installApp();
                                  }
                                : null,
                            child: const Text('Proceed Installation'),
                          );
                        }
                        return LyFilledButton(
                          onPressed: () {
                            controller.finish();
                          },
                          child: Text(l10n.finish),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
