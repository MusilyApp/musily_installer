import 'package:get/get.dart';
import 'package:musily_installer/infra/services/linux_service.dart';
import '../../mixins/page_controller_mixin.dart';
import 'dart:io';
import 'package:musily_installer/generated/app_localizations.dart';

class UninstallerController extends GetxController with PageControllerMixin {
  bool acceptedUninstall = false;
  bool removeAppData = true;
  bool installing = false;
  String status = '';
  String terminalOutput = '';
  bool showTerminalOutput = false;
  double uninstallProgress = 0.0;
  bool isMusilyRunning = false;

  void setAcceptedUninstall(bool value) {
    acceptedUninstall = value;
    update();
  }

  void setRemoveAppData(bool value) {
    removeAppData = value;
    update();
  }

  void setShowTerminalOutput(bool value) {
    showTerminalOutput = value;
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
        // Use string interpolation for the message since we haven't generated the new translations yet
        terminalOutput +=
            'Found running Musily process (PID: $musicProcess), terminating...\n';
        await Process.run('kill', [musicProcess!]);
        await Future.delayed(const Duration(milliseconds: 500));

        final checkResult = await Process.run('ps', ['-p', musicProcess]);
        final checkOutput = checkResult.stdout.toString().trim().split('\n');
        isMusilyRunning = checkOutput.length > 1;

        if (isMusilyRunning) {
          status = l10n
              .error('Unable to terminate Musily. Please close it manually.');
          terminalOutput +=
              'Warning: Failed to terminate Musily. Please close it manually.\n';
        } else {
          status = 'Musily process terminated successfully';
          terminalOutput += 'Musily process terminated successfully.\n';
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

  Future<void> uninstallApp() async {
    final l10n = AppLocalizations.of(Get.context!);
    installing = true;
    status = 'Checking if Musily is running...';
    uninstallProgress = 0.0;
    update();

    if (await checkMusilyProcess()) {
      installing = false;
      update();
      return;
    }

    status = l10n.uninstallTitle;
    update();

    try {
      terminalOutput = 'Removing application files...\n';
      uninstallProgress = 0.3;
      update();

      await LinuxService.uninstallMusily();

      if (removeAppData) {
        terminalOutput += 'Removing application data...\n';
        uninstallProgress = 0.6;
        update();

        final appDataDir =
            '${Platform.environment['HOME']}/.var/app/app.musily.music';
        try {
          await Directory(appDataDir).delete(recursive: true);
          terminalOutput += 'Application data removed successfully.\n';
        } catch (e) {
          terminalOutput +=
              '${l10n.error('Failed to remove application data: $e')}\n';
        }
      }

      try {
        terminalOutput += 'Updating desktop database...\n';
        uninstallProgress = 0.9;
        update();
        await LinuxService.updateDesktopCache();
      } catch (e) {
        terminalOutput +=
            '${l10n.error('Failed to update desktop database.')}\n';
        update();
      }

      await Future.delayed(const Duration(seconds: 1));
      installing = false;
      status = l10n.uninstallationComplete;
      terminalOutput += '${l10n.uninstallationCompleteMessage}\n';
      uninstallProgress = 1.0;
      nextPage();
      update();
    } catch (e) {
      installing = false;
      status = l10n.error(e.toString());
      terminalOutput += '${l10n.error(e.toString())}\n';
      update();
    }
  }

  void finish() {
    exit(0);
  }
}
