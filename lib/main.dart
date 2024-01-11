import 'package:brasiltoon/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages_routes/pages_routes.dart';
import 'package:get/get.dart';

void main() async {
  Get.put(AuthController());
  WidgetsFlutterBinding.ensureInitialized();

  // try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //      } catch (e) {
  //  print('Erro durante a inicialização do Firebase: $e');
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Brasiltoon',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: PagesRoutes.splashRoute,
      getPages: AppPages.pages,
    );
  }
}
