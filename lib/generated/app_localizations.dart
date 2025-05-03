import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('uk')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Musily Installer'**
  String get appTitle;

  /// No description provided for @updateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Musily'**
  String get updateTitle;

  /// No description provided for @installTitle.
  ///
  /// In en, this message translates to:
  /// **'Install Musily'**
  String get installTitle;

  /// No description provided for @uninstallTitle.
  ///
  /// In en, this message translates to:
  /// **'Uninstall Musily'**
  String get uninstallTitle;

  /// No description provided for @warningUninstall.
  ///
  /// In en, this message translates to:
  /// **'Warning: Uninstall Musily'**
  String get warningUninstall;

  /// No description provided for @warningUninstallMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove Musily from your system. Your music library and preferences will be deleted.'**
  String get warningUninstallMessage;

  /// No description provided for @uninstallConfirmation.
  ///
  /// In en, this message translates to:
  /// **'I understand that this action cannot be undone'**
  String get uninstallConfirmation;

  /// No description provided for @removeAppData.
  ///
  /// In en, this message translates to:
  /// **'Remove all app data'**
  String get removeAppData;

  /// No description provided for @uninstallButton.
  ///
  /// In en, this message translates to:
  /// **'Uninstall Musily'**
  String get uninstallButton;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current version: {version}'**
  String currentVersion(String version);

  /// No description provided for @installationProgress.
  ///
  /// In en, this message translates to:
  /// **'Installation Progress'**
  String get installationProgress;

  /// No description provided for @uninstallationProgress.
  ///
  /// In en, this message translates to:
  /// **'Uninstallation Progress'**
  String get uninstallationProgress;

  /// No description provided for @updateProgress.
  ///
  /// In en, this message translates to:
  /// **'Update Progress'**
  String get updateProgress;

  /// No description provided for @showTerminalOutput.
  ///
  /// In en, this message translates to:
  /// **'Show terminal output'**
  String get showTerminalOutput;

  /// No description provided for @installationComplete.
  ///
  /// In en, this message translates to:
  /// **'Installation Complete'**
  String get installationComplete;

  /// No description provided for @uninstallationComplete.
  ///
  /// In en, this message translates to:
  /// **'Uninstallation Complete'**
  String get uninstallationComplete;

  /// No description provided for @updateComplete.
  ///
  /// In en, this message translates to:
  /// **'Update Complete'**
  String get updateComplete;

  /// No description provided for @installationCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Musily has been successfully installed on your system.'**
  String get installationCompleteMessage;

  /// No description provided for @uninstallationCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Musily has been successfully removed from your system.'**
  String get uninstallationCompleteMessage;

  /// No description provided for @updateCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Musily has been successfully updated.'**
  String get updateCompleteMessage;

  /// No description provided for @runAfterInstall.
  ///
  /// In en, this message translates to:
  /// **'Run Musily after installation'**
  String get runAfterInstall;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// Tooltip for the language selection button
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @checkingMusily.
  ///
  /// In en, this message translates to:
  /// **'Checking if Musily is running...'**
  String get checkingMusily;

  /// Message shown when a running Musily process is found
  ///
  /// In en, this message translates to:
  /// **'Found running Musily process (PID: {pid}), terminating...'**
  String foundRunningMusily(String pid);

  /// No description provided for @musilyTerminated.
  ///
  /// In en, this message translates to:
  /// **'Musily process terminated successfully'**
  String get musilyTerminated;

  /// No description provided for @removingAppFiles.
  ///
  /// In en, this message translates to:
  /// **'Removing application files...'**
  String get removingAppFiles;

  /// No description provided for @removingAppData.
  ///
  /// In en, this message translates to:
  /// **'Removing application data...'**
  String get removingAppData;

  /// No description provided for @appDataRemoved.
  ///
  /// In en, this message translates to:
  /// **'Application data removed successfully'**
  String get appDataRemoved;

  /// No description provided for @failedRemoveData.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove application data: {error}'**
  String failedRemoveData(String error);

  /// No description provided for @updatingDesktopDb.
  ///
  /// In en, this message translates to:
  /// **'Updating desktop database...'**
  String get updatingDesktopDb;

  /// No description provided for @failedUpdateDb.
  ///
  /// In en, this message translates to:
  /// **'Failed to update desktop database'**
  String get failedUpdateDb;

  /// No description provided for @unableToTerminate.
  ///
  /// In en, this message translates to:
  /// **'Unable to terminate Musily. Please close it manually.'**
  String get unableToTerminate;

  /// No description provided for @installingDependencies.
  ///
  /// In en, this message translates to:
  /// **'Installing missing dependencies...'**
  String get installingDependencies;

  /// No description provided for @dependenciesInstalled.
  ///
  /// In en, this message translates to:
  /// **'Dependencies installed successfully.'**
  String get dependenciesInstalled;

  /// No description provided for @failedInstallDeps.
  ///
  /// In en, this message translates to:
  /// **'Failed to install dependencies'**
  String get failedInstallDeps;

  /// No description provided for @backingUpConfig.
  ///
  /// In en, this message translates to:
  /// **'Backing up configuration...'**
  String get backingUpConfig;

  /// No description provided for @restoringConfig.
  ///
  /// In en, this message translates to:
  /// **'Restoring configuration...'**
  String get restoringConfig;

  /// No description provided for @installingIcon.
  ///
  /// In en, this message translates to:
  /// **'Installing application icon...'**
  String get installingIcon;

  /// No description provided for @creatingDesktopEntry.
  ///
  /// In en, this message translates to:
  /// **'Creating desktop entry...'**
  String get creatingDesktopEntry;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
