import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

class WindowsUtils {
  static Future<String?> selectFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Installation Directory',
      initialDirectory: Platform.environment['ProgramFiles'],
    );

    if (selectedDirectory == null) {
      // User cancelled the picker
      final programFiles = Platform.environment['ProgramFiles'];
      return programFiles != null
          ? path.join(programFiles, 'YourApp')
          : r'C:\Program Files\YourApp';
    }

    return selectedDirectory;
  }

  static Future<void> createShortcut(
    String exePath,
    String shortcutPath,
  ) async {
    // Create a batch file shortcut
    final batchContent = '''
@echo off
start "" "${exePath.replaceAll(r'\', r'\\')}"
''';

    final shortcutBat = shortcutPath.replaceAll('.lnk', '.bat');
    await File(shortcutBat).writeAsString(batchContent);
  }

  static Future<void> createStartMenuShortcut(
    String appName,
    String exePath,
  ) async {
    final startMenu = path.join(
      Platform.environment['APPDATA']!,
      'Microsoft\\Windows\\Start Menu\\Programs',
      appName,
    );

    await Directory(startMenu).create(recursive: true);
    final shortcutPath = path.join(startMenu, '$appName.lnk');
    await createShortcut(exePath, shortcutPath);
  }
}
