import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/custom_text_field.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/services/validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _formkey = GlobalKey<FormState>();
  final authcontroller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cadastro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                  //formulario
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              icon: Icons.email,
                              label: 'Email',
                              onSaved: (value) {
                                authcontroller.user.email = value;
                              },
                              validator: emailValidator,
                              textInputType: TextInputType.emailAddress,
                            ),
                            CustomTextField(
                              icon: Icons.lock,
                              label: 'senha',
                              onSaved: (value) {
                                authcontroller.user.password = value;
                              },
                              validator: passowrdValidator,
                              isSecret: true,
                            ),
                            CustomTextField(
                              icon: Icons.person,
                              label: 'Nome',
                              onSaved: (value) {
                                authcontroller.user.name = value;
                              },
                              validator: nameValiadtor,
                            ),
                            CustomTextField(
                              icon: Icons.phone,
                              label: 'Celular',
                              onSaved: (value) {
                                authcontroller.user.phone = value;
                              },
                              validator: phoneValidator,
                              textInputType: TextInputType.phone,
                              inputFormatters: [phoneFormatter],
                            ),
                            CustomTextField(
                              icon: Icons.file_copy,
                              label: 'Cpf',
                              onSaved: (value) {
                                authcontroller.user.cpf = value;
                              },
                              validator: cpfValidator,
                              textInputType: TextInputType.number,
                              inputFormatters: [cpfFormatter],
                            ),
                            SizedBox(
                              height: 50,
                              child: Obx(() {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                  ),
                                  onPressed: authcontroller.isloading.value
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          if (_formkey.currentState!
                                              .validate()) {
                                            _formkey.currentState!.save();
                                            authcontroller.signUp();
                                            print(authcontroller.user);
                                          }
                                        },
                                  child: authcontroller.isloading.value
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Cadastrar usuario',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                );
                              }),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: SafeArea(
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
