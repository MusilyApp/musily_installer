import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowService {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;
  WindowService._internal();

  String windowTitle = 'Musily';
  String currentTitle = 'Musily';

  bool isMaximized = false;

  static Future<void> init() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(720, 600),
      center: true,
      minimumSize: Size(720, 600),
      maximumSize: Size(720, 600),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    WindowService().isMaximized = await windowManager.isMaximized();
  }

  static Future<void> showWindow() async {
    windowManager.show();
    windowManager.focus();
  }

  static Future<void> setWindowTitle(
    String title, {
    bool defaultTitle = false,
  }) async {
    if (title == WindowService().currentTitle && !defaultTitle) {
      return;
    }
    if (defaultTitle) {
      await windowManager.setTitle(WindowService().windowTitle);
      WindowService().currentTitle = WindowService().windowTitle;
    }
    await windowManager.setTitle(title);
    WindowService().currentTitle = title;
  }
}
