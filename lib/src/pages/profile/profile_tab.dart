import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/custom_text_field.dart';
import 'package:brasiltoon/src/services/validator.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do usuario'),
        actions: [
          IconButton(
            onPressed: () {
              authController.signOut();
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          //foto de perfil

          //email
          CustomTextField(
            readeOnly: true,
            initialValue: authController.user.email,
            icon: Icons.email,
            label: 'Email',
          ),
          //Nome

          CustomTextField(
            readeOnly: true,
            initialValue: authController.user.name,
            icon: Icons.person,
            label: 'Nome',
          ),
          //celular
          CustomTextField(
            readeOnly: true,
            initialValue: authController.user.phone,
            icon: Icons.phone,
            label: 'Celular',
          ),
          //cpf
          CustomTextField(
            readeOnly: true,
            initialValue: authController.user.cpf,
            icon: Icons.file_copy,
            label: 'CPF',
            isSecret: true,
          ),
          //Botão de atualizar senha
          SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.green,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                updatePassword();
              },
              child: const Text('Atualizar senha'),
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> updatePassword() {
    final newPasswordController = TextEditingController();
    final currentPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //titulo
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Atulização de senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //senha atual
                        CustomTextField(
                          controller: currentPasswordController,
                          isSecret: true,
                          icon: Icons.lock,
                          label: ' Senha atual',
                          validator: passowrdValidator,
                        ),
                        //nova senha
                        CustomTextField(
                          controller: newPasswordController,
                          isSecret: true,
                          icon: Icons.lock,
                          label: 'Nova senha',
                          validator: passowrdValidator,
                        ),
                        //comfirmar senha
                        CustomTextField(
                          isSecret: true,
                          icon: Icons.lock,
                          label: 'Comfirmar nova senha',
                          validator: (password) {
                            final result = passowrdValidator(password);
                            if (result != null) {
                              return result;
                            }
                            if (password != newPasswordController.text) {
                              return ' As senhas não são equivalentes';
                            }
                            return null;
                          },
                        ),
                        //botão de comfirmação
                        SizedBox(
                          height: 45,
                          child: Obx(() => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: authController.isloading.value
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          authController.changePassword(
                                            currentPassword:
                                                currentPasswordController.text,
                                            newPassword:
                                                newPasswordController.text,
                                          );
                                        }
                                      },
                                child: authController.isloading.value
                                    ? const CircularProgressIndicator()
                                    : const Text('Atualizar'),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ))
              ],
            ),
          );
        });
  }
}
