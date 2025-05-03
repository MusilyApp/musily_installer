import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musily_installer/app/modules/installer/installer_controller.dart';

class LicensePage extends StatelessWidget {
  const LicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'License Agreement',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please read the following license agreement carefully:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: GetBuilder<InstallerController>(builder: (controller) {
                  return Text(
                    controller.licenseText,
                    style: const TextStyle(fontSize: 14),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GetBuilder<InstallerController>(builder: (controller) {
            return CheckboxListTile(
              value: controller.acceptedLicense,
              onChanged: (value) =>
                  controller.setAcceptedLicense(value ?? false),
              title: const Text(
                'I accept the terms of the License Agreement',
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }
}
