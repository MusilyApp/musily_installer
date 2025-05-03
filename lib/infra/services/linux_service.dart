import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;

enum InstallState { notInstalled, installed, readyToUninstall }

class LinuxService {
  static Future<InstallState> checkInstallation() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    // Check if this is an uninstaller by checking for a specific asset
    try {
      // Try to load a small asset that should always be present in your app
      // but would be missing in the uninstaller
      await rootBundle.load('assets/app/musily.tar.gz');
    } catch (e) {
      // If we can't load the marker file, this is probably an uninstaller
      print('Installer marker not found, assuming uninstaller mode');
      return InstallState.readyToUninstall;
    }

    // Check all required files for a complete installation
    final execFile = File(path.join(homeDir, '.musily', 'musily'));
    final iconFile = File(
        path.join(homeDir, '.local', 'share', 'icons', 'app.musily.music.svg'));
    final desktopFile = File(path.join(
        homeDir, '.local', 'share', 'applications', 'musily.desktop'));

    final execExists = await execFile.exists();
    final iconExists = await iconFile.exists();
    final desktopExists = await desktopFile.exists();

    // Only consider it installed if ALL files are present
    if (execExists && iconExists && desktopExists) {
      return InstallState.installed;
    }

    // If any file is missing, treat as not installed
    return InstallState.notInstalled;
  }

  static Future<void> uninstallMusily() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    // Remove application files
    final appDir = Directory(path.join(homeDir, '.musily'));
    if (await appDir.exists()) {
      await appDir.delete(recursive: true);
    }

    // Remove icon
    final iconFile = File(
        path.join(homeDir, '.local', 'share', 'icons', 'app.musily.music.svg'));
    if (await iconFile.exists()) {
      await iconFile.delete();
    }

    // Remove desktop entry
    final desktopFile = File(path.join(
        homeDir, '.local', 'share', 'applications', 'musily.desktop'));
    if (await desktopFile.exists()) {
      await desktopFile.delete();
    }

    // Update desktop database
    try {
      await updateDesktopCache();
    } catch (e) {
      // Ignore errors during uninstall
    }
  }

  static Future<void> installIcon() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    final iconDir = Directory(path.join(homeDir, '.local', 'share', 'icons'));
    await iconDir.create(recursive: true);

    final iconDest = File(path.join(iconDir.path, 'app.musily.music.svg'));

    // Try to load the SVG icon from Flutter assets
    try {
      final iconSourceDir = Directory(path.join(homeDir, '.musily', 'data',
          'flutter_assets', 'assets', 'icons', 'app.musily.music.svg'));
      final iconData = File(iconSourceDir.path);
      await iconDest.writeAsBytes(iconData.readAsBytesSync());
      print('Icon installed from rootBundle to ${iconDest.path}');
    } catch (e) {
      print('Failed to load icon from rootBundle: $e');
      throw Exception('Could not install icon: $e');
    }
  }

  static Future<void> extractTarGz(
      String tarPath, String destinationPath) async {
    final result = await Process.run('tar', [
      'xzf',
      tarPath,
      '-C',
      destinationPath,
    ]);

    if (result.exitCode != 0) {
      throw Exception('Failed to extract tar.gz file: ${result.stderr}');
    }
  }

  static Future<void> copyAppFiles() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    final appDir = Directory(path.join(homeDir, '.musily'));
    await appDir.create(recursive: true);

    try {
      // Load the tar.gz file from Flutter assets
      final tarGzData = await rootBundle.load('assets/app/musily.tar.gz');

      // Create a temporary file to store the tar.gz
      final tempTarPath = path.join(appDir.path, 'temp_musily.tar.gz');
      final tempTarFile = File(tempTarPath);
      await tempTarFile.writeAsBytes(tarGzData.buffer.asUint8List());

      print('Tar.gz file created at: $tempTarPath');

      // Extract the tar.gz file
      await extractTarGz(tempTarPath, appDir.path);

      // Remove the temporary tar.gz file after extraction
      await tempTarFile.delete();
      print('Temporary tar.gz file deleted');

      // Make the executable file executable
      final execFile = File(path.join(appDir.path, 'musily'));
      if (await execFile.exists()) {
        await Process.run('chmod', ['+x', execFile.path]);
        print('Made executable file executable: ${execFile.path}');
      } else {
        print('Warning: Executable file not found at: ${execFile.path}');
      }
    } catch (e) {
      print('Error copying app files: $e');
      throw Exception('Failed to copy app files: $e');
    }
  }

  static Future<void> installDesktopFile() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    final desktopDir =
        Directory(path.join(homeDir, '.local', 'share', 'applications'));
    await desktopDir.create(recursive: true);

    final desktopContent = '''[Desktop Entry]
Version=1.0
Type=Application

Name=Musily
Comment=A great music app.
Categories=AudioVideo;

Icon=app.musily.music
Exec=$homeDir/.musily/musily
Terminal=false
StartupWMClass=musily''';

    final desktopDest = File(
      path.join(
        desktopDir.path,
        'musily.desktop',
      ),
    );

    // Write/overwrite the desktop file
    await desktopDest.writeAsString(desktopContent);

    // Make the desktop file executable
    await Process.run('chmod', ['+x', desktopDest.path]);

    print('Desktop file installed at: ${desktopDest.path}');
  }

  static Future<void> updateDesktopCache() async {
    try {
      // Try different desktop environment specific commands
      final desktopEnv =
          Platform.environment['XDG_CURRENT_DESKTOP']?.toLowerCase() ?? '';

      if (desktopEnv.contains('gnome')) {
        await Process.run('gio', ['mime', '--update']);
      } else if (desktopEnv.contains('kde')) {
        await Process.run('kbuildsycoca5', []);
      } else if (desktopEnv.contains('cinnamon')) {
        await Process.run('cinnamon', ['--replace', '&']);
      }

      // Generic update for all environments
      await Process.run('update-desktop-database', [
        path.join(
            Platform.environment['HOME']!, '.local', 'share', 'applications')
      ]);
    } catch (e) {
      // If the specific commands fail, it's not critical
      print('Warning: Could not update desktop cache: $e');
    }
  }
}
