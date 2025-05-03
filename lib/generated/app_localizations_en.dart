// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Musily Installer';

  @override
  String get updateTitle => 'Update Musily';

  @override
  String get installTitle => 'Install Musily';

  @override
  String get uninstallTitle => 'Uninstall Musily';

  @override
  String get warningUninstall => 'Warning: Uninstall Musily';

  @override
  String get warningUninstallMessage => 'This will remove Musily from your system. Your music library and preferences will be deleted.';

  @override
  String get uninstallConfirmation => 'I understand that this action cannot be undone';

  @override
  String get removeAppData => 'Remove all app data';

  @override
  String get uninstallButton => 'Uninstall Musily';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String currentVersion(String version) {
    return 'Current version: $version';
  }

  @override
  String get installationProgress => 'Installation Progress';

  @override
  String get uninstallationProgress => 'Uninstallation Progress';

  @override
  String get updateProgress => 'Update Progress';

  @override
  String get showTerminalOutput => 'Show terminal output';

  @override
  String get installationComplete => 'Installation Complete';

  @override
  String get uninstallationComplete => 'Uninstallation Complete';

  @override
  String get updateComplete => 'Update Complete';

  @override
  String get installationCompleteMessage => 'Musily has been successfully installed on your system.';

  @override
  String get uninstallationCompleteMessage => 'Musily has been successfully removed from your system.';

  @override
  String get updateCompleteMessage => 'Musily has been successfully updated.';

  @override
  String get runAfterInstall => 'Run Musily after installation';

  @override
  String get finish => 'Finish';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get changeLanguage => 'Change language';

  @override
  String get checkingMusily => 'Checking if Musily is running...';

  @override
  String foundRunningMusily(String pid) {
    return 'Found running Musily process (PID: $pid), terminating...';
  }

  @override
  String get musilyTerminated => 'Musily process terminated successfully';

  @override
  String get removingAppFiles => 'Removing application files...';

  @override
  String get removingAppData => 'Removing application data...';

  @override
  String get appDataRemoved => 'Application data removed successfully';

  @override
  String failedRemoveData(String error) {
    return 'Failed to remove application data: $error';
  }

  @override
  String get updatingDesktopDb => 'Updating desktop database...';

  @override
  String get failedUpdateDb => 'Failed to update desktop database';

  @override
  String get unableToTerminate => 'Unable to terminate Musily. Please close it manually.';

  @override
  String get installingDependencies => 'Installing missing dependencies...';

  @override
  String get dependenciesInstalled => 'Dependencies installed successfully.';

  @override
  String get failedInstallDeps => 'Failed to install dependencies';

  @override
  String get backingUpConfig => 'Backing up configuration...';

  @override
  String get restoringConfig => 'Restoring configuration...';

  @override
  String get installingIcon => 'Installing application icon...';

  @override
  String get creatingDesktopEntry => 'Creating desktop entry...';
}
