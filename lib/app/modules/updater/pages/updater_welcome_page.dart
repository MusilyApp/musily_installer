import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musily_installer/app/modules/updater/updater_controller.dart';
import 'package:musily_installer/app/widgets/musily_logo.dart';

class UpdaterWelcomePage extends StatelessWidget {
  const UpdaterWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MusilyLogo(
            size: 100,
          ),
          const Text(
            'Musily Updater',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GetBuilder<UpdaterController>(builder: (controller) {
            return Text(
              'You are installing ${controller.appVersion} version of Musily.',
              style: const TextStyle(fontSize: 16),
            );
          }),
        ],
      ),
    );
  }
}
