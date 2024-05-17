import 'package:brasiltoon/src/pages/auth/view/sign_in_screen.dart';
import 'package:brasiltoon/src/pages/auth/view/sign_up_screen.dart';
import 'package:brasiltoon/src/pages/base/base_screen.dart';
import 'package:brasiltoon/src/pages/base/binding/navigation_binding.dart';
import 'package:brasiltoon/src/pages/cart/binding/cart_binding.dart';
import 'package:brasiltoon/src/pages/coin/binding/coin_binding.dart';
import 'package:brasiltoon/src/pages/editor_perfil/binding/perfil_binding.dart';
import 'package:brasiltoon/src/pages/favorites/binding/favorites_binding.dart';
import 'package:brasiltoon/src/pages/story_editing/binding/editing_binding.dart';
import 'package:brasiltoon/src/pages/home/binding/home_binding.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/binding/cape_product_binding.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/binding/publish_chapter_binding.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/binding/pages_produt_binding.dart';
import 'package:brasiltoon/src/pages/publishers/binding/publishers_binding.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/binding/product_pages_chapter_binding.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/binding/product_chapter_binding.dart';
import 'package:brasiltoon/src/pages/splash/splash_screen.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      page: () => const SplashScreen(),
      name: PagesRoutes.splashRoute,
    ),
    GetPage(
      page: () => SignInScreen(),
      name: PagesRoutes.signInRoute,
    ),
    GetPage(
      page: () => const SignUpScreen(),
      name: PagesRoutes.signUpRoute,
    ),
    GetPage(
      page: () => const BaseScreen(),
      name: PagesRoutes.baseRoute,
      bindings: [
        NavigationBinding(),
        HomeBinding(),
        ProductChapterBinding(),
        ProductPagesChapterBinding(),
        FavoritesBinding(),
        PublishersBinding(),
        CapeProductBinding(),
        ChapterBinding(),
        PagesBinding(),
        EditingBinding(),
        CartBinding(),
        CoinBinding(),
        PerfilBinding(),
      ],
    ),
  ];
}

abstract class PagesRoutes {
  static const String productChapterRoute = '/product';
  static const String signInRoute = '/signin';
  static const String signUpRoute = '/signup';
  static const String splashRoute = '/splash';
  static const String baseRoute = '/';
}
