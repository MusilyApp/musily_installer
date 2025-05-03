import 'package:flutter/material.dart';

class DependenciesPage extends StatelessWidget {
  final Map<String, bool> dependencies;
  final bool acceptedDependencies;
  final Function(bool) onAcceptDependencies;

  const DependenciesPage({
    super.key,
    required this.dependencies,
    required this.acceptedDependencies,
    required this.onAcceptDependencies,
  });

  @override
  Widget build(BuildContext context) {
    final hasMissingDependencies = dependencies.entries.any((e) => !e.value);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Dependencies',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'The following dependencies are required:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: dependencies.length,
                itemBuilder: (context, index) {
                  final entry = dependencies.entries.elementAt(index);
                  final packageName = entry.key;
                  final displayName = packageName
                      .replaceAll('lib', '')
                      .replaceAll('-dev', '')
                      .replaceAll('-', ' ')
                      .trim()
                      .split(' ')
                      .map((word) => word[0].toUpperCase() + word.substring(1))
                      .join(' ');

                  return ListTile(
                    leading: Icon(
                      entry.value ? Icons.check_circle : Icons.warning,
                      color: entry.value ? Colors.green : Colors.orange,
                    ),
                    title: Text(displayName),
                    subtitle: Text(
                      entry.value ? 'Already installed' : 'Will be installed',
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (hasMissingDependencies)
            CheckboxListTile(
              value: acceptedDependencies,
              onChanged: (value) => onAcceptDependencies(value!),
              title: const Text(
                'I understand that these dependencies will be installed on my system',
                style: TextStyle(fontSize: 16),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}
