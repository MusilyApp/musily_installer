import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musily_installer/app/modules/updater/pages/updater_welcome_page.dart';
import 'package:musily_installer/app/widgets/ui/buttons/ly_filled_button.dart';
import 'package:musily_installer/generated/app_localizations.dart';
import 'updater_controller.dart';
import '../../widgets/dependencies_page.dart';
import '../../widgets/progress_page.dart';
import '../../widgets/done_page.dart';

class UpdaterView extends StatelessWidget {
  const UpdaterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GetBuilder<UpdaterController>(
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
                    const UpdaterWelcomePage(),
                    if (controller.hasMissingDependencies())
                      DependenciesPage(
                        dependencies: controller.dependencies,
                        acceptedDependencies: controller.acceptedDependencies,
                        onAcceptDependencies:
                            controller.setAcceptedDependencies,
                      ),
                    ProgressPage(
                      title: l10n.updateProgress,
                      progress: controller.installProgress,
                      status: controller.status,
                      terminalOutput: controller.terminalOutput,
                      showTerminalOutput: controller.showTerminalOutput,
                      onToggleTerminalOutput: controller.setShowTerminalOutput,
                      showCacheError: controller.cacheUpdateFailed,
                    ),
                    DonePage(
                      title: l10n.updateComplete,
                      message: 'Musily has been successfully updated.',
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
                  Builder(
                    builder: (context) {
                      if (controller.currentPage == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: LyFilledButton(
                            onPressed: () {
                              controller.setCurrentPage(1);
                              controller.updateApp();
                            },
                            child: Text(l10n.next),
                          ),
                        );
                      } else if (controller.currentPage == 1 &&
                          controller.hasMissingDependencies()) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: LyFilledButton(
                            onPressed: controller.acceptedDependencies
                                ? () {
                                    controller.setCurrentPage(2);
                                    controller.updateApp();
                                  }
                                : null,
                            child: const Text('Update Musily'),
                          ),
                        );
                      } else if (controller.currentPage == 1 &&
                              !controller.hasMissingDependencies() ||
                          controller.currentPage == 2 &&
                              controller.hasMissingDependencies()) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: LyFilledButton(
                          onPressed: () {
                            controller.finish();
                          },
                          child: Text(l10n.finish),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
