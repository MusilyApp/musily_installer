// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Instalador de Musily';

  @override
  String get updateTitle => 'Actualizar Musily';

  @override
  String get installTitle => 'Instalar Musily';

  @override
  String get uninstallTitle => 'Desinstalar Musily';

  @override
  String get warningUninstall => 'Advertencia: Desinstalar Musily';

  @override
  String get warningUninstallMessage => 'Esto eliminará Musily de su sistema. Su biblioteca de música y preferencias serán eliminadas.';

  @override
  String get uninstallConfirmation => 'Entiendo que esta acción no se puede deshacer';

  @override
  String get removeAppData => 'Eliminar todos los datos de la aplicación';

  @override
  String get uninstallButton => 'Desinstalar Musily';

  @override
  String get updateAvailable => 'Actualización Disponible';

  @override
  String currentVersion(String version) {
    return 'Versión actual: $version';
  }

  @override
  String get installationProgress => 'Progreso de Instalación';

  @override
  String get uninstallationProgress => 'Progreso de Desinstalación';

  @override
  String get updateProgress => 'Progreso de Actualización';

  @override
  String get showTerminalOutput => 'Mostrar salida del terminal';

  @override
  String get installationComplete => 'Instalación Completada';

  @override
  String get uninstallationComplete => 'Desinstalación Completada';

  @override
  String get updateComplete => 'Actualización Completada';

  @override
  String get installationCompleteMessage => 'Musily se ha instalado correctamente en su sistema.';

  @override
  String get uninstallationCompleteMessage => 'Musily se ha eliminado correctamente de su sistema.';

  @override
  String get updateCompleteMessage => 'Musily se ha actualizado correctamente.';

  @override
  String get runAfterInstall => 'Ejecutar Musily después de la instalación';

  @override
  String get finish => 'Finalizar';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get cancel => 'Cancelar';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get checkingMusily => 'Comprobando si Musily está en ejecución...';

  @override
  String foundRunningMusily(String pid) {
    return 'Se encontró un proceso de Musily en ejecución (PID: $pid), terminando...';
  }

  @override
  String get musilyTerminated => 'Proceso de Musily terminado con éxito';

  @override
  String get removingAppFiles => 'Eliminando archivos de la aplicación...';

  @override
  String get removingAppData => 'Eliminando datos de la aplicación...';

  @override
  String get appDataRemoved => 'Datos de la aplicación eliminados con éxito';

  @override
  String failedRemoveData(String error) {
    return 'Error al eliminar los datos de la aplicación: $error';
  }

  @override
  String get updatingDesktopDb => 'Actualizando base de datos de escritorio...';

  @override
  String get failedUpdateDb => 'Error al actualizar la base de datos de escritorio';

  @override
  String get unableToTerminate => 'No se puede terminar Musily. Por favor, ciérrelo manualmente.';

  @override
  String get installingDependencies => 'Instalando dependencias faltantes...';

  @override
  String get dependenciesInstalled => 'Dependencias instaladas correctamente.';

  @override
  String get failedInstallDeps => 'Error al instalar las dependencias';

  @override
  String get backingUpConfig => 'Respaldando configuración...';

  @override
  String get restoringConfig => 'Restaurando configuración...';

  @override
  String get installingIcon => 'Instalando icono de la aplicación...';

  @override
  String get creatingDesktopEntry => 'Creando entrada de escritorio...';
}
