import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/base/controller/navigation_controller.dart';
import 'package:brasiltoon/src/pages/favorites/view/favorites_tab.dart';
import 'package:brasiltoon/src/pages/home/view/home_tab.dart';
import 'package:brasiltoon/src/pages/profile/profile_tab.dart';
import 'package:brasiltoon/src/pages/publishers/view/publishers_tab.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final navigationController = Get.find<NavigationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: navigationController.pageController,
        children: const [
          HomeTab(),
          FavoritesTab(),
          // CoinTab(),
          PublishersTab(),
          ProfileTab(),
          //CartTab(),
        ],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navigationController.currentIndex,
            onTap: (index) {
              navigationController.navigatePageview(index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.green,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withAlpha(100),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_add),
                label: 'Favoritos',
              ),
              /*   BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Coins',
              ),*/
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'Editores',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Perfil',
              ),
            ],
          )),
    );
  }
}
