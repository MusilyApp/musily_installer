import 'dart:io';

enum PackageManager { apt, dnf, pacman, unknown }

class LinuxDependencyService {
  static final Map<PackageManager, Map<String, String>> _packageNames = {
    PackageManager.apt: {
      'libmpv': 'libmpv-dev',
      'libsecret': 'libsecret-1-dev',
      'libjsoncpp': 'libjsoncpp-dev',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator3-dev',
    },
    PackageManager.dnf: {
      'libmpv': 'mpv-libs-devel',
      'libsecret': 'libsecret-devel',
      'libjsoncpp': 'jsoncpp-devel',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libappindicator-gtk3-devel',
    },
    PackageManager.pacman: {
      'libmpv': 'mpv',
      'libsecret': 'libsecret',
      'libjsoncpp': 'jsoncpp',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libappindicator-gtk3',
    },
  };

  static Future<PackageManager> _detectPackageManager() async {
    try {
      // Check for apt (Debian/Ubuntu)
      if (await _commandExists('apt')) {
        return PackageManager.apt;
      }
      // Check for dnf (Fedora)
      if (await _commandExists('dnf')) {
        return PackageManager.dnf;
      }
      // Check for pacman (Arch)
      if (await _commandExists('pacman')) {
        return PackageManager.pacman;
      }
      return PackageManager.unknown;
    } catch (e) {
      return PackageManager.unknown;
    }
  }

  static Future<bool> _commandExists(String command) async {
    try {
      final result = await Process.run('which', [command]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, bool>> checkDependencies() async {
    if (!Platform.isLinux) return {};

    final packageManager = await _detectPackageManager();
    if (packageManager == PackageManager.unknown) return {};

    final packages = _packageNames[packageManager]!;
    final result = <String, bool>{};

    // Use the generic names as keys, but check the distro-specific package names
    for (final entry in packages.entries) {
      final genericName = entry.key;
      final packageName = entry.value;
      final installed = await _isPackageInstalled(packageName, packageManager);
      result[genericName] = installed;
    }
    return result;
  }

  static Future<bool> _isPackageInstalled(
    String packageName,
    PackageManager manager,
  ) async {
    try {
      switch (manager) {
        case PackageManager.apt:
          // Use dpkg-query instead of dpkg -s for more reliable status checking
          final result = await Process.run(
              'dpkg-query', ['-W', '-f=\${Status}', packageName]);
          return result.exitCode == 0 &&
              result.stdout.toString().contains('install ok installed');
        case PackageManager.dnf:
          // Use rpm -q with --quiet flag for cleaner output
          final result =
              await Process.run('rpm', ['-q', '--quiet', packageName]);
          return result.exitCode == 0;
        case PackageManager.pacman:
          // Use -Q instead of -Qi for more reliable checking
          final result = await Process.run('pacman', ['-Q', packageName]);
          return result.exitCode == 0;
        case PackageManager.unknown:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> installMissingDependencies(
      List<String> genericPackages) async {
    if (genericPackages.isEmpty) return true;

    final packageManager = await _detectPackageManager();
    if (packageManager == PackageManager.unknown) return false;

    // Convert generic package names to distro-specific ones
    final packages = genericPackages
        .map((name) => _packageNames[packageManager]![name] ?? name)
        .toList();

    try {
      switch (packageManager) {
        case PackageManager.apt:
          return _installWithApt(packages);
        case PackageManager.dnf:
          return _installWithDnf(packages);
        case PackageManager.pacman:
          return _installWithPacman(packages);
        case PackageManager.unknown:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _installWithApt(List<String> packages) async {
    final result = await Process.run('pkexec', [
      'bash',
      '-c',
      'apt-get update && apt-get install -y ${packages.join(" ")}',
    ]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithDnf(List<String> packages) async {
    final result = await Process.run('pkexec', [
      'dnf',
      'install',
      '-y',
      ...packages,
    ]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithPacman(List<String> packages) async {
    final result = await Process.run('pkexec', [
      'pacman',
      '-Sy',
      '--noconfirm',
      ...packages,
    ]);
    return result.exitCode == 0;
  }
}
