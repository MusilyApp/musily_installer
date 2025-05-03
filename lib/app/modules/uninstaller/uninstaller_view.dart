import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musily_installer/app/widgets/ui/buttons/ly_filled_button.dart';
import 'package:musily_installer/generated/app_localizations.dart';
import 'uninstaller_controller.dart';
import 'pages/uninstall_warning_page.dart';
import '../../widgets/progress_page.dart';
import '../../widgets/done_page.dart';

class UninstallerView extends StatelessWidget {
  const UninstallerView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GetBuilder<UninstallerController>(
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
                    const UninstallWarningPage(),
                    ProgressPage(
                      title: l10n.uninstallationProgress,
                      progress: controller.uninstallProgress,
                      status: controller.status,
                      terminalOutput: controller.terminalOutput,
                      showTerminalOutput: controller.showTerminalOutput,
                      onToggleTerminalOutput: controller.setShowTerminalOutput,
                      showCacheError: false,
                    ),
                    DonePage(
                      title: l10n.uninstallationComplete,
                      message: l10n.uninstallationCompleteMessage,
                      isUninstall: true,
                      showRunOption: false,
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
                            onPressed: controller.acceptedUninstall
                                ? () {
                                    controller.setCurrentPage(1);
                                    controller.uninstallApp();
                                  }
                                : null,
                            child: Text(l10n.uninstallButton),
                          );
                        }
                        if (controller.currentPage == 1) {
                          return const SizedBox.shrink();
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
