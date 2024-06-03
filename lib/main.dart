import 'package:brasiltoon/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages_routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  Get.put(AuthController());

  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'yourAppId';
  //"H13T1aiOUr09EFLEcNTWgpUZsVhf2b0hsogOQZim"; //'yourAppId';
  const keyClientKey = 'yourMasterKey';
  //   'zMKV2c3Fh8fLG51ufUNH7Bkh6Wmphq9sVh1m0a6i'; //'yourMasterKey';
  const keyParseServerUrl =
      // 'https://terrier-equipped-supposedly.ngrok-free.app/parse/';
      // 'https://parseapi.back4app.com';
      'http://localhost:1337/parse';
  try {
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        masterKey: keyClientKey, debug: true);
  } catch (e) {
    print('Erro durante a inicialização do parse: $e');
  }
  // try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //      } catch (e) {
  //  print('Erro durante a inicialização do Firebase: $e');
  // }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
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
