// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:musily_installer/infra/services/linux_dependency_service.dart';
import 'package:musily_installer/infra/services/linux_service.dart';
import 'package:musily_installer/generated/app_localizations.dart';
import '../../mixins/page_controller_mixin.dart';
import 'dart:io';

class UpdaterController extends GetxController with PageControllerMixin {
  bool runAfterInstall = true;
  bool installing = false;
  String status = '';
  String terminalOutput = '';
  bool showTerminalOutput = false;
  bool cacheUpdateFailed = false;
  Map<String, bool> dependencies = {};
  double installProgress = 0.0;
  bool acceptedDependencies = false;
  String appVersion = '1.0.0';
  bool isMusilyRunning = false;

  @override
  void onInit() {
    super.onInit();
    checkDependencies();
    checkAppVersion();
  }

  void checkAppVersion() async {
    final l10n = AppLocalizations.of(Get.context!);
    try {
      final version = await rootBundle.loadString('assets/app/version.txt');
      appVersion = version.trim();
      terminalOutput = '${l10n.currentVersion(appVersion)}\n';
      update();
    } catch (e) {
      status = l10n.error(e.toString());
      terminalOutput += '${l10n.error(e.toString())}\n';
      update();
    }
  }

  void setRunAfterInstall(bool value) {
    runAfterInstall = value;
    update();
  }

  void setShowTerminalOutput(bool value) {
    showTerminalOutput = value;
    update();
  }

  Future<void> checkDependencies() async {
    dependencies = await LinuxDependencyService.checkDependencies();
    update();
  }

  void setAcceptedDependencies(bool value) {
    acceptedDependencies = value;
    update();
  }

  Future<bool> checkMusilyProcess() async {
    final l10n = AppLocalizations.of(Get.context!);
    try {
      final result = await Process.run('ps', ['-eo', 'pid,cmd']);
      final processes = result.stdout.toString().split('\n');

      final musicAppPath = '${Platform.environment['HOME']}/.musily/musily';
      final musicProcess = processes
          .map((process) => process.trim().split(RegExp(r'\s+')))
          .where((parts) =>
              parts.length > 1 && parts.skip(1).join(' ') == musicAppPath)
          .map((parts) => parts[0])
          .firstOrNull;

      isMusilyRunning = musicProcess != null;

      if (isMusilyRunning) {
        terminalOutput += '${l10n.foundRunningMusily(musicProcess!)}\n';
        await Process.run('kill', [musicProcess]);
        await Future.delayed(const Duration(milliseconds: 500));

        final checkResult = await Process.run('ps', ['-p', musicProcess]);
        final checkOutput = checkResult.stdout.toString().trim().split('\n');
        isMusilyRunning = checkOutput.length > 1;

        if (isMusilyRunning) {
          status = l10n.unableToTerminate;
          terminalOutput += '${l10n.unableToTerminate}\n';
        } else {
          status = l10n.musilyTerminated;
          terminalOutput += l10n.musilyTerminated + '\n';
        }
      }
      update();
      return isMusilyRunning;
    } catch (e) {
      status = 'Error checking/terminating Musily process: $e';
      terminalOutput += 'Error checking/terminating Musily process: $e\n';
      return false;
    }
  }

  Future<void> updateApp() async {
    final l10n = AppLocalizations.of(Get.context!);
    installing = true;
    status = l10n.checkingMusily;
    installProgress = 0.0;
    update();

    if (await checkMusilyProcess()) {
      installing = false;
      update();
      return;
    }

    status = l10n.updateTitle;
    update();

    try {
      final missingDeps = dependencies.entries
          .where((e) => !e.value)
          .map((e) => e.key)
          .toList();

      if (missingDeps.isNotEmpty) {
        terminalOutput = l10n.installingDependencies + '\n';
        installProgress = 0.2;
        update();

        if (await LinuxDependencyService.installMissingDependencies(
            missingDeps)) {
          await checkDependencies();
          terminalOutput += l10n.dependenciesInstalled + '\n';
          installProgress = 0.4;
          update();
        } else {
          throw Exception(l10n.failedInstallDeps);
        }
      }

      status = l10n.updateProgress;
      terminalOutput += l10n.backingUpConfig + '\n';
      installProgress = 0.5;
      update();

      // await LinuxService.backupConfig();

      terminalOutput += l10n.removingAppFiles + '\n';
      installProgress = 0.7;
      update();

      // Double-check that Musily isn't running before copying files
      if (await checkMusilyProcess()) {
        throw Exception(l10n.unableToTerminate);
      }

      await LinuxService.copyAppFiles();

      terminalOutput += l10n.restoringConfig + '\n';
      installProgress = 0.8;
      update();

      // await LinuxService.restoreConfig();

      try {
        terminalOutput += l10n.updatingDesktopDb + '\n';
        installProgress = 0.9;
        update();
        await LinuxService.updateDesktopCache();
      } catch (e) {
        cacheUpdateFailed = true;
        terminalOutput += l10n.failedUpdateDb + '\n';
        update();
      }

      installing = false;
      status = l10n.updateComplete;
      terminalOutput += l10n.updateCompleteMessage + '\n';
      installProgress = 1.0;
      await Future.delayed(const Duration(seconds: 1));
      nextPage();
      update();
    } catch (e) {
      installing = false;
      status = l10n.error(e.toString());
      terminalOutput += l10n.error(e.toString()) + '\n';
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
