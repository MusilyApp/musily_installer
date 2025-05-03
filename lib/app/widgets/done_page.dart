import 'package:flutter/material.dart';

class DonePage extends StatelessWidget {
  final String title;
  final String message;
  final bool isUninstall;
  final bool showRunOption;
  final bool runAfterFinish;
  final bool showCacheError;
  final Function(bool)? onRunOptionChanged;

  const DonePage({
    super.key,
    required this.title,
    required this.message,
    this.isUninstall = false,
    this.showRunOption = true,
    this.runAfterFinish = true,
    this.showCacheError = false,
    this.onRunOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUninstall
                ? Icons.delete_forever_outlined
                : Icons.check_circle_outline,
            size: 64,
            color: isUninstall ? Colors.red : Colors.green,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (showCacheError) ...[
            const SizedBox(height: 16),
            const Text(
              'Note: The app will appear in your applications menu after you restart your system.',
              style: TextStyle(
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showRunOption && !isUninstall) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: runAfterFinish,
                  onChanged: (value) {
                    if (onRunOptionChanged != null) {
                      onRunOptionChanged!(value!);
                    }
                  },
                ),
                const Text('Run Musily after closing installer'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
