import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:musily_installer/infra/services/linux_dependency_service.dart';
import 'package:musily_installer/infra/services/linux_service.dart';
import 'package:musily_installer/generated/app_localizations.dart';
import '../../mixins/page_controller_mixin.dart';
import 'dart:io';

class InstallerController extends GetxController with PageControllerMixin {
  bool acceptedLicense = false;
  bool acceptedDependencies = false;
  bool runAfterInstall = true;
  bool installing = false;
  String status = '';
  String terminalOutput = '';
  bool showTerminalOutput = false;
  bool cacheUpdateFailed = false;
  Map<String, bool> dependencies = {};
  double installProgress = 0.0;
  String licenseText = '';

  @override
  void onInit() {
    super.onInit();
    checkDependencies();
    loadLicenseText();
  }

  void setAcceptedLicense(bool value) {
    acceptedLicense = value;
    update();
  }

  void setAcceptedDependencies(bool value) {
    acceptedDependencies = value;
    update();
  }

  void setRunAfterInstall(bool value) {
    runAfterInstall = value;
    update();
  }

  void setShowTerminalOutput(bool value) {
    showTerminalOutput = value;
    update();
  }

  Future<void> loadLicenseText() async {
    final l10n = AppLocalizations.of(Get.context!);
    try {
      final license = await rootBundle.loadString('assets/app/LICENSE');
      licenseText = license;
    } catch (e) {
      licenseText = l10n.error('Error loading license: $e');
    }
    update();
  }

  Future<void> checkDependencies() async {
    dependencies = await LinuxDependencyService.checkDependencies();
    update();
  }

  Future<void> installApp() async {
    final l10n = AppLocalizations.of(Get.context!);
    installing = true;
    status = l10n.installTitle;
    installProgress = 0.0;
    update();

    try {
      final missingDeps = dependencies.entries
          .where((e) => !e.value)
          .map((e) => e.key)
          .toList();

      if (missingDeps.isNotEmpty) {
        terminalOutput = '${l10n.installationProgress}\n';
        installProgress = 0.2;
        update();

        if (await LinuxDependencyService.installMissingDependencies(
            missingDeps)) {
          await checkDependencies();
          terminalOutput += '${l10n.installationComplete}\n';
          installProgress = 0.4;
          update();
        } else {
          throw Exception(l10n.error('Failed to install dependencies'));
        }
      }

      status = l10n.installTitle;
      terminalOutput += '${l10n.removingAppFiles}\n';
      installProgress = 0.6;
      update();

      const appPath = 'assets/app';
      await LinuxService.copyAppFiles(appPath);

      terminalOutput += 'Installing application icon...\n';
      installProgress = 0.7;
      update();
      await LinuxService.installIcon(appPath);

      terminalOutput += 'Creating desktop entry...\n';
      installProgress = 0.8;
      update();
      await LinuxService.installDesktopFile(appPath);

      try {
        terminalOutput += '${l10n.updatingDesktopDb}\n';
        installProgress = 0.9;
        update();
        await LinuxService.updateDesktopCache();
      } catch (e) {
        cacheUpdateFailed = true;
        terminalOutput += '${l10n.failedUpdateDb}\n';
        update();
      }

      installing = false;
      status = l10n.installationComplete;
      terminalOutput += '${l10n.installationCompleteMessage}\n';
      installProgress = 1.0;
      await Future.delayed(const Duration(seconds: 1), () {
        setCurrentPage(4);
      });
      update();
    } catch (e) {
      installing = false;
      status = l10n.error(e.toString());
      terminalOutput += '${l10n.error(e.toString())}\n';
      update();
    }
  }

  Future<void> finish() async {
    if (runAfterInstall) {
      await Process.start(
        '${Platform.environment['HOME']}/.musily/musily',
        [],
        mode: ProcessStartMode.detached,
      );
    }
    exit(0);
  }

  bool hasMissingDependencies() {
    return dependencies.entries.any((e) => !e.value);
  }
}
