import 'dart:io';

enum PackageManager {
  apt,
  dnf,
  pacman,
  zypper,
  apk,
  xbps,
  nix,
  emerge,
  unknown,
}

class LinuxDependencyService {
  static final Map<PackageManager, Map<String, String>> _packageNames = {
    PackageManager.apt: {
      'libmpv': 'libmpv-dev',
      'libsecret': 'libsecret-1-dev',
      'libjsoncpp': 'libjsoncpp-dev',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator3-dev',
      'curl': 'curl',
    },
    PackageManager.dnf: {
      'libmpv': 'mpv-devel',
      'libsecret': 'libsecret-devel',
      'libjsoncpp': 'jsoncpp-devel',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator-gtk3-devel',
      'curl': 'curl',
    },
    PackageManager.pacman: {
      'libmpv': 'mpv',
      'libsecret': 'libsecret',
      'libjsoncpp': 'jsoncpp',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator',
      'curl': 'curl',
    },
    PackageManager.zypper: {
      'libmpv': 'libmpv-devel',
      'libsecret': 'libsecret-devel',
      'libjsoncpp': 'jsoncpp-devel',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator',
      'curl': 'curl',
    },
    PackageManager.apk: {
      'libmpv': 'mpv-dev',
      'libsecret': 'libsecret-dev',
      'libjsoncpp': 'jsoncpp-dev',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator-dev',
      'curl': 'curl',
    },
    PackageManager.xbps: {
      'libmpv': 'mpv-devel',
      'libsecret': 'libsecret-devel',
      'libjsoncpp': 'jsoncpp-devel',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator',
      'curl': 'curl',
    },
    PackageManager.nix: {
      'libmpv': 'libmpv',
      'libsecret': 'libsecret',
      'libjsoncpp': 'jsoncpp',
      'gnomekeyring': 'gnome-keyring',
      'appindicator': 'libayatana-appindicator',
      'curl': 'curl',
    },
    PackageManager.emerge: {
      'libmpv': 'media-video/mpv',
      'libsecret': 'gnome-base/libsecret',
      'libjsoncpp': 'dev-libs/jsoncpp',
      'gnomekeyring': 'gnome-base/gnome-keyring',
      'appindicator': 'dev-libs/libayatana-appindicator',
      'curl': 'net-misc/curl',
    },
  };

  static Future<PackageManager> _detectPackageManager() async {
    final managers = {
      'apt': PackageManager.apt,
      'dnf': PackageManager.dnf,
      'pacman': PackageManager.pacman,
      'zypper': PackageManager.zypper,
      'apk': PackageManager.apk,
      'xbps-install': PackageManager.xbps,
      'nix-env': PackageManager.nix,
      'emerge': PackageManager.emerge,
    };
    for (final entry in managers.entries) {
      if (await _commandExists(entry.key)) {
        return entry.value;
      }
    }
    return PackageManager.unknown;
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
      String packageName, PackageManager manager) async {
    try {
      switch (manager) {
        case PackageManager.apt:
          final result = await Process.run(
              'dpkg-query', ['-W', '-f=\${Status}', packageName]);
          return result.exitCode == 0 &&
              result.stdout.toString().contains('install ok installed');
        case PackageManager.dnf:
        case PackageManager.zypper:
        case PackageManager.xbps:
        case PackageManager.emerge:
          final result = await Process.run('rpm', ['-q', packageName]);
          return result.exitCode == 0;
        case PackageManager.pacman:
          final result = await Process.run('pacman', ['-Q', packageName]);
          return result.exitCode == 0;
        case PackageManager.apk:
          final result = await Process.run('apk', ['info', packageName]);
          return result.stdout.toString().contains(packageName);
        case PackageManager.nix:
          final result = await Process.run('nix-env', ['-q', packageName]);
          return result.stdout.toString().contains(packageName);
        case PackageManager.unknown:
          return false;
      }
    } catch (_) {
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
        case PackageManager.zypper:
          return _installWithZypper(packages);
        case PackageManager.apk:
          return _installWithApk(packages);
        case PackageManager.xbps:
          return _installWithXbps(packages);
        case PackageManager.nix:
          return _installWithNix(packages);
        case PackageManager.emerge:
          return _installWithEmerge(packages);
        case PackageManager.unknown:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _installWithApt(List<String> packages) async {
    final result = await _runWithPrivileges([
      'bash',
      '-c',
      'apt-get update && apt-get install -y ${packages.join(" ")}'
    ]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithDnf(List<String> packages) async {
    final result =
        await _runWithPrivileges(['dnf', 'install', '-y', ...packages]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithPacman(List<String> packages) {
    final result =
        _runWithPrivileges(['pacman', '-Sy', '--noconfirm', ...packages]);
    return result.then((result) => result.exitCode == 0);
  }

  static Future<bool> _installWithZypper(List<String> packages) async {
    final result = await _runWithPrivileges(
        ['zypper', '--non-interactive', 'install', ...packages]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithApk(List<String> packages) async {
    final result = await _runWithPrivileges(['apk', 'add', ...packages]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithXbps(List<String> packages) async {
    final result =
        await _runWithPrivileges(['xbps-install', '-Sy', ...packages]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithNix(List<String> packages) async {
    final result = await _runWithPrivileges(
        ['nix-env', '-iA', ...packages.map((e) => 'nixpkgs.$e')]);
    return result.exitCode == 0;
  }

  static Future<bool> _installWithEmerge(List<String> packages) async {
    final result = await _runWithPrivileges(['emerge', ...packages]);
    return result.exitCode == 0;
  }

  static Future<ProcessResult> _runWithPrivileges(List<String> args) {
    return Process.run('pkexec', args);
  }
}
