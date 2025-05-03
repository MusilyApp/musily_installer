import 'dart:io';
import 'package:path/path.dart' as path;

enum InstallState { notInstalled, installed, readyToUninstall }

class LinuxService {
  static Future<InstallState> checkInstallation() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    // First check if this is an uninstaller (empty assets)
    final assetsPath = Directory('assets/app');
    if (!await assetsPath.exists() ||
        (await assetsPath.list().toList()).isEmpty) {
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

  static Future<void> installIcon(String assetsPath) async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    final iconDir = Directory(path.join(homeDir, '.local', 'share', 'icons'));
    await iconDir.create(recursive: true);

    final iconSource = File(
      path.join(
        assetsPath,
        'data',
        'flutter_assets',
        'assets',
        'icons',
        'app.musily.music.svg',
      ),
    );
    final iconDest = File(path.join(iconDir.path, 'app.musily.music.svg'));

    // Copy with overwrite if exists
    if (await iconDest.exists()) {
      await iconDest.delete();
    }
    await iconSource.copy(iconDest.path);
  }

  static Future<void> copyAppFiles(String assetsPath) async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) throw Exception('Could not get HOME directory');

    final appDir = Directory(path.join(homeDir, '.musily'));
    await appDir.create(recursive: true);

    // Copy all files from assets recursively
    final sourceDir = Directory(assetsPath);
    await _copyDirectory(sourceDir, appDir);

    // Make the executable file executable
    final execFile = File(path.join(appDir.path, 'musily'));
    if (await execFile.exists()) {
      await Process.run('chmod', ['+x', execFile.path]);
    }
  }

  static Future<void> _copyDirectory(
      Directory source, Directory destination) async {
    await for (var entity in source.list(recursive: false)) {
      if (entity is Directory) {
        final newDirectory =
            Directory(path.join(destination.path, path.basename(entity.path)));
        await newDirectory.create();
        await _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        await entity
            .copy(path.join(destination.path, path.basename(entity.path)));
      }
    }
  }

  static Future<void> installDesktopFile(String assetsPath) async {
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
