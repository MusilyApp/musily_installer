import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  final String title;
  final double progress;
  final String status;
  final String terminalOutput;
  final bool showTerminalOutput;
  final Function(bool) onToggleTerminalOutput;
  final bool showCacheError;

  const ProgressPage({
    super.key,
    required this.title,
    required this.progress,
    required this.status,
    required this.terminalOutput,
    required this.showTerminalOutput,
    required this.onToggleTerminalOutput,
    this.showCacheError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 16),
          Text(
            status,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => onToggleTerminalOutput(!showTerminalOutput),
                icon: Icon(
                  showTerminalOutput ? Icons.expand_less : Icons.expand_more,
                ),
                label: Text(
                  showTerminalOutput ? 'Hide Details' : 'Show Details',
                ),
              ),
            ],
          ),
          if (showTerminalOutput) ...[
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          terminalOutput,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (showCacheError) ...[
            const SizedBox(height: 16),
            const Text(
              'Note: Desktop entry cache update failed. The app will appear in your applications menu after you restart your system.',
              style: TextStyle(
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
