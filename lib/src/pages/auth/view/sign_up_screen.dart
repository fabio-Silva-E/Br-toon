import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/custom_text_field.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/services/validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final imagePicker = ImagePicker();

  File? imageFile;
  //File imageFile = File('assets/perfil/perfil-de-usuario.png');
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
      /* appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            0), // Define a altura como zero para ocultar o AppBar
        child: AppBar(
          leading: const IconButton(
            onPressed: null,
            icon: Icon(PhosphorIcons.bell_bold),
            color: Colors.black54,
          ),
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(PhosphorIcons.bell),
              color: Colors.black54,
            ),
          ],
        ),
      ),*/
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 75,
                                      backgroundColor:
                                          const Color.fromARGB(99, 71, 67, 67),
                                      child: CircleAvatar(
                                        radius: 65,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: imageFile != null
                                            ? FileImage(imageFile!)
                                            : const AssetImage(
                                                    'assets/perfil/perfil-de-usuario.png')
                                                as ImageProvider,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        child: IconButton(
                                          onPressed: _showOpcoesBottomSheet,
                                          icon: Icon(
                                            PhosphorIcons.camera,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                  onPressed: authcontroller.isLoading.value
                                      ? null
                                      : () async {
                                          FocusScope.of(context).unfocus();
                                          if (_formkey.currentState!
                                              .validate()) {
                                            _formkey.currentState!.save();
                                            String imagePath;
                                            if (imageFile != null) {
                                              imagePath = await authcontroller
                                                  .saveImageToAppDirectory(
                                                      File(imageFile!.path));
                                            } else {
                                              // Carregar imagem de ativos e salvar
                                              ByteData data = await rootBundle.load(
                                                  'assets/perfil/perfil-de-usuario.png');
                                              List<int> bytes =
                                                  data.buffer.asUint8List();
                                              imagePath = await authcontroller
                                                  .saveImageToAppDirectoryFromBytes(
                                                      bytes);
                                            }
                                            authcontroller.user.userphoto =
                                                imagePath;

                                            await authcontroller.signUp();
                                            print(authcontroller.user);
                                          }
                                        },
                                  child: authcontroller.isLoading.value
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

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } /* else {
      // Se o usuário cancelar a escolha da imagem, use a imagem padrão
      setState(() {
        imageFile = File('assets/perfil/perfil-de-usuario.png');
      });
    }*/
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Buscar imagem da galeria
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Fazer foto da câmera
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.trash,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Tornar a foto null
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
