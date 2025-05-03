import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:musily_installer/app/widgets/ui/window/ly_header_bar.dart';
import 'package:musily_installer/infra/services/linux_service.dart';
import 'package:musily_installer/infra/services/window_service.dart';
import 'package:musily_installer/generated/app_localizations.dart';
import 'app/app_binding.dart';
import 'app/modules/installer/installer_view.dart';
import 'app/modules/updater/updater_view.dart';
import 'app/modules/uninstaller/uninstaller_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowService.init();
  final state = await LinuxService.checkInstallation();
  runApp(MusilyInstaller(initialState: state));
}

class MusilyInstaller extends StatelessWidget {
  final InstallState initialState;

  const MusilyInstaller({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Musily Installer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('pt', 'BR'), // Brazilian Portuguese
        Locale('es'), // Spanish
        Locale('ru'), // Russian
        Locale('uk'), // Ukrainian
      ],
      locale: Get.deviceLocale, // Use device locale
      fallbackLocale: const Locale('en'), // Default to English
      initialBinding: AppBinding(),
      home: Scaffold(
        appBar: const LyHeaderBar(),
        body: _buildInitialView(),
      ),
    );
  }

  Widget _buildInitialView() {
    switch (initialState) {
      case InstallState.installed:
        return const UpdaterView();
      case InstallState.readyToUninstall:
        return const UninstallerView();
      case InstallState.notInstalled:
        return const InstallerView();
    }
  }
}
