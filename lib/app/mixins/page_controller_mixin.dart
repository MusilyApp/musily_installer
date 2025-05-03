import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin PageControllerMixin on GetxController {
  late final PageController pageController;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void setCurrentPage(int value) {
    if (value != currentPage) {
      currentPage = value;
      pageController.animateToPage(
        value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  void nextPage() {
    setCurrentPage(currentPage + 1);
  }

  void previousPage() {
    if (currentPage > 0) {
      setCurrentPage(currentPage - 1);
    }
  }
}
