import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class NavigationTabs {
  static const int Home = 0;
  static const int Favorites = 1;
  static const int Orders = 2;
  static const int Publishers = 3;
  static const int Profile = 4;
}

class NavigationController extends GetxController {
  late PageController _pageController;
  late RxInt _currentIndex;

  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    _initNavigation(
      pageController: PageController(initialPage: NavigationTabs.Home),
      currentIndex: NavigationTabs.Home,
    );
  }

  void _initNavigation({
    required PageController pageController,
    required int currentIndex,
  }) {
    _pageController = pageController;
    _currentIndex = currentIndex.obs;
  }

  void navigatePageview(int page) {
    if (_currentIndex.value == page) return;

    // _pageController.jumpToPage(page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    _currentIndex.value = page;
  }
}
