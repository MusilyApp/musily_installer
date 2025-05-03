// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Встановлювач Musily';

  @override
  String get updateTitle => 'Оновити Musily';

  @override
  String get installTitle => 'Встановити Musily';

  @override
  String get uninstallTitle => 'Видалити Musily';

  @override
  String get warningUninstall => 'Увага: Видалення Musily';

  @override
  String get warningUninstallMessage => 'Це видалить Musily з вашої системи. Вашу музичну бібліотеку та налаштування буде видалено.';

  @override
  String get uninstallConfirmation => 'Я розумію, що цю дію не можна скасувати';

  @override
  String get removeAppData => 'Видалити всі дані програми';

  @override
  String get uninstallButton => 'Видалити Musily';

  @override
  String get updateAvailable => 'Доступне Оновлення';

  @override
  String currentVersion(String version) {
    return 'Поточна версія: $version';
  }

  @override
  String get installationProgress => 'Прогрес Встановлення';

  @override
  String get uninstallationProgress => 'Прогрес Видалення';

  @override
  String get updateProgress => 'Прогрес Оновлення';

  @override
  String get showTerminalOutput => 'Показати вивід терміналу';

  @override
  String get installationComplete => 'Встановлення Завершено';

  @override
  String get uninstallationComplete => 'Видалення Завершено';

  @override
  String get updateComplete => 'Оновлення Завершено';

  @override
  String get installationCompleteMessage => 'Musily успішно встановлено у вашій системі.';

  @override
  String get uninstallationCompleteMessage => 'Musily успішно видалено з вашої системи.';

  @override
  String get updateCompleteMessage => 'Musily успішно оновлено.';

  @override
  String get runAfterInstall => 'Запустити Musily після встановлення';

  @override
  String get finish => 'Завершити';

  @override
  String get next => 'Далі';

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Скасувати';

  @override
  String error(String message) {
    return 'Помилка: $message';
  }

  @override
  String get changeLanguage => 'Змінити мову';

  @override
  String get checkingMusily => 'Перевірка, чи запущено Musily...';

  @override
  String foundRunningMusily(String pid) {
    return 'Знайдено запущений процес Musily (PID: $pid), завершення...';
  }

  @override
  String get musilyTerminated => 'Процес Musily успішно завершено';

  @override
  String get removingAppFiles => 'Видалення файлів програми...';

  @override
  String get removingAppData => 'Видалення даних програми...';

  @override
  String get appDataRemoved => 'Дані програми успішно видалено';

  @override
  String failedRemoveData(String error) {
    return 'Не вдалося видалити дані програми: $error';
  }

  @override
  String get updatingDesktopDb => 'Оновлення бази даних робочого столу...';

  @override
  String get failedUpdateDb => 'Не вдалося оновити базу даних робочого столу';

  @override
  String get unableToTerminate => 'Не вдається завершити Musily. Будь ласка, закрийте його вручну.';

  @override
  String get installingDependencies => 'Встановлення відсутніх залежностей...';

  @override
  String get dependenciesInstalled => 'Залежності успішно встановлено.';

  @override
  String get failedInstallDeps => 'Не вдалося встановити залежності';

  @override
  String get backingUpConfig => 'Резервне копіювання конфігурації...';

  @override
  String get restoringConfig => 'Відновлення конфігурації...';

  @override
  String get installingIcon => 'Встановлення значка програми...';

  @override
  String get creatingDesktopEntry => 'Створення ярлика в меню програм...';
}
