// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Установщик Musily';

  @override
  String get updateTitle => 'Обновить Musily';

  @override
  String get installTitle => 'Установить Musily';

  @override
  String get uninstallTitle => 'Удалить Musily';

  @override
  String get warningUninstall => 'Внимание: Удаление Musily';

  @override
  String get warningUninstallMessage => 'Это удалит Musily из вашей системы. Ваша музыкальная библиотека и настройки будут удалены.';

  @override
  String get uninstallConfirmation => 'Я понимаю, что это действие нельзя отменить';

  @override
  String get removeAppData => 'Удалить все данные приложения';

  @override
  String get uninstallButton => 'Удалить Musily';

  @override
  String get updateAvailable => 'Доступно Обновление';

  @override
  String currentVersion(String version) {
    return 'Текущая версия: $version';
  }

  @override
  String get installationProgress => 'Прогресс Установки';

  @override
  String get uninstallationProgress => 'Прогресс Удаления';

  @override
  String get updateProgress => 'Прогресс Обновления';

  @override
  String get showTerminalOutput => 'Показать вывод терминала';

  @override
  String get installationComplete => 'Установка Завершена';

  @override
  String get uninstallationComplete => 'Удаление Завершено';

  @override
  String get updateComplete => 'Обновление Завершено';

  @override
  String get installationCompleteMessage => 'Musily успешно установлен в вашей системе.';

  @override
  String get uninstallationCompleteMessage => 'Musily успешно удален из вашей системы.';

  @override
  String get updateCompleteMessage => 'Musily успешно обновлен.';

  @override
  String get runAfterInstall => 'Запустить Musily после установки';

  @override
  String get finish => 'Завершить';

  @override
  String get next => 'Далее';

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Отмена';

  @override
  String error(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get changeLanguage => 'Изменить язык';

  @override
  String get checkingMusily => 'Проверка, запущен ли Musily...';

  @override
  String foundRunningMusily(String pid) {
    return 'Найден запущенный процесс Musily (PID: $pid), завершение...';
  }

  @override
  String get musilyTerminated => 'Процесс Musily успешно завершен';

  @override
  String get removingAppFiles => 'Удаление файлов приложения...';

  @override
  String get removingAppData => 'Удаление данных приложения...';

  @override
  String get appDataRemoved => 'Данные приложения успешно удалены';

  @override
  String failedRemoveData(String error) {
    return 'Не удалось удалить данные приложения: $error';
  }

  @override
  String get updatingDesktopDb => 'Обновление базы данных рабочего стола...';

  @override
  String get failedUpdateDb => 'Не удалось обновить базу данных рабочего стола';

  @override
  String get unableToTerminate => 'Не удается завершить Musily. Пожалуйста, закройте его вручную.';

  @override
  String get installingDependencies => 'Установка недостающих зависимостей...';

  @override
  String get dependenciesInstalled => 'Зависимости успешно установлены.';

  @override
  String get failedInstallDeps => 'Не удалось установить зависимости';

  @override
  String get backingUpConfig => 'Резервное копирование конфигурации...';

  @override
  String get restoringConfig => 'Восстановление конфигурации...';

  @override
  String get installingIcon => 'Установка значка приложения...';

  @override
  String get creatingDesktopEntry => 'Создание ярлыка в меню приложений...';
}
