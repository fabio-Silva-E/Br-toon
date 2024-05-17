import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/auth/view/components/forgot_password_dialog.dart';
import 'package:brasiltoon/src/pages/common_widgets/custom_text_field.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages_routes/app_pages.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:brasiltoon/src/services/validator.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  //controlador de campo
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final utilsServices = UtilsServices();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /* const AppNameWidget(
                      brasilTileColor: Color.fromARGB(255, 255, 195, 195),
                      textSize: 40,
                    ),*/
                    SizedBox(
                      height: 200,
                      child: Image.asset('assets/logo/brtoon.png'),
                    ),
                    //categorias
                    SizedBox(
                      height: 30,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('mangas'),
                            FadeAnimatedText('aventuras'),
                            FadeAnimatedText('editores'),
                            FadeAnimatedText('leitores'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //formulario

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    )),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Email
                      CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        label: 'Email',
                        validator: emailValidator,
                      ),

                      //Senha
                      CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock,
                        label: 'Senha',
                        isSecret: true,
                        validator: passowrdValidator,
                      ),
                      //botão entrar
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(
                          builder: (authcontroller) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.customSwatchColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                              ),
                              onPressed: authcontroller.isLoading.value
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();

                                      if (_formKey.currentState!.validate()) {
                                        String email = emailController.text;
                                        String password =
                                            passwordController.text;
                                        authcontroller.signIn(
                                            email: email, password: password);
                                      }
                                    },
                              child: authcontroller.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                      //esqueceu a senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            final bool? result = await showDialog(
                                context: context,
                                builder: (_) {
                                  return ForgotPasswordDialog(
                                    email: emailController.text,
                                  );
                                });
                            if (result ?? false) {
                              utilsServices.showToast(
                                message:
                                    'um link de recuperação foi enviado ao seu email',
                              );
                            }
                          },
                          child: Text(
                            'esqueceu a senha?',
                            style: TextStyle(
                              color: CustomColors.redContrastColor,
                            ),
                          ),
                        ),
                      ),
                      //divisor
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('Ou'),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //criar conta
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(PagesRoutes.signUpRoute);
                          },
                          child: const Text('Criar conta',
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
