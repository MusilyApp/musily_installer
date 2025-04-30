import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'windows_utils.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    // Check for necessary permissions
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        // Show error dialog and exit if no permission
        runApp(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Administrator privileges are required.\nPlease run the installer as administrator.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => exit(1),
                      child: const Text('Exit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        return;
      }
    }
  }

  runApp(const InstallerApp());
}

class InstallerApp extends StatelessWidget {
  const InstallerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Installer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const InstallerScreen(),
    );
  }
}

class InstallerScreen extends StatefulWidget {
  const InstallerScreen({super.key});

  @override
  State<InstallerScreen> createState() => _InstallerScreenState();
}

class _InstallerScreenState extends State<InstallerScreen> {
  int _currentStep = 0;
  bool _acceptedLicense = false;
  String _installPath = '';
  double _installProgress = 0;
  bool _isInstalling = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initInstallPath();
  }

  Future<void> _initInstallPath() async {
    final programFiles = Platform.environment['ProgramFiles'];
    setState(() {
      _installPath = path.join(programFiles ?? 'C:\\Program Files', 'YourApp');
    });
  }

  Future<void> _selectInstallPath() async {
    final selectedPath = await WindowsUtils.selectFolder();
    if (selectedPath != null) {
      setState(() {
        _installPath = selectedPath;
      });
    }
  }

  Future<void> _copyFiles(String destinationDir) async {
    try {
      // Get the list of files in the assets/app directory
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestContent);

      final appFiles =
          manifest.keys
              .where((String key) => key.startsWith('assets/app/'))
              .toList();

      for (var i = 0; i < appFiles.length; i++) {
        final assetPath = appFiles[i];
        final fileName = path.basename(assetPath);
        final targetPath = path.join(destinationDir, fileName);

        // Read the file from assets and write to destination
        final data = await rootBundle.load(assetPath);
        final bytes = data.buffer.asUint8List();
        await File(targetPath).writeAsBytes(bytes);

        setState(() {
          _installProgress = 0.2 + (0.6 * (i + 1) / appFiles.length);
          _statusMessage = 'Copying: $fileName';
        });
      }
    } catch (e) {
      throw Exception('Failed to copy files: $e');
    }
  }

  Future<void> _install() async {
    setState(() {
      _isInstalling = true;
      _statusMessage = 'Preparing installation...';
    });

    try {
      // Create installation directory
      final dir = Directory(_installPath);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }

      // Copy application files
      setState(() {
        _statusMessage = 'Copying files...';
        _installProgress = 0.2;
      });

      await _copyFiles(_installPath);

      // Create start menu shortcut
      setState(() {
        _statusMessage = 'Creating shortcuts...';
        _installProgress = 0.8;
      });

      final exePath = path.join(_installPath, 'YourApp.exe');
      await WindowsUtils.createStartMenuShortcut('YourApp', exePath);

      setState(() {
        _statusMessage = 'Installation completed successfully!';
        _installProgress = 1.0;
        _currentStep = 3; // Move to completion step
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error during installation: $e';
      });
    } finally {
      setState(() {
        _isInstalling = false;
      });
    }
  }

  Future<void> _launchApplication() async {
    final exePath = path.join(_installPath, 'YourApp.exe');
    await Process.start(exePath, []);
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stepper(
          currentStep: _currentStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  if (_currentStep < 3)
                    ElevatedButton(
                      onPressed:
                          !_isInstalling &&
                                  (_currentStep != 1 || _acceptedLicense)
                              ? () {
                                if (_currentStep == 2) {
                                  _install();
                                } else {
                                  setState(() => _currentStep++);
                                }
                              }
                              : null,
                      child: Text(_currentStep == 2 ? 'Install' : 'Next'),
                    ),
                  if (_currentStep > 0 && _currentStep < 3 && !_isInstalling)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep == 3)
                    ElevatedButton(
                      onPressed: () => _launchApplication(),
                      child: const Text('Launch Application'),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Welcome'),
              content: const Text(
                'Welcome to the installation wizard. This will install YourApp on your computer.',
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('License Agreement'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Please read and accept the license agreement:'),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const SingleChildScrollView(
                      child: Text('''
License Agreement

[Your license agreement text here]
'''),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('I accept the license agreement'),
                    value: _acceptedLicense,
                    onChanged:
                        (value) => setState(() => _acceptedLicense = value!),
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Installation Location'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select installation location:'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          initialValue: _installPath,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _selectInstallPath,
                        child: const Text('Browse'),
                      ),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('Installing'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isInstalling) ...[
                    LinearProgressIndicator(value: _installProgress),
                    const SizedBox(height: 8),
                  ],
                  Text(_statusMessage),
                ],
              ),
              isActive: _currentStep >= 3,
            ),
          ],
        ),
      ),
    );
  }
}
