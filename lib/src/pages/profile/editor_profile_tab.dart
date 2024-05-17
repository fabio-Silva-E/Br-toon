import 'package:brasiltoon/src/pages/common_widgets/build_text_field.dart';
import 'package:brasiltoon/src/pages/editor_perfil/controller/perfil_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilTab extends StatefulWidget {
  final String userId;
  const PerfilTab({
    // required this.user,
    required this.userId,
    super.key,
  });

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  late bool _isLoading;
  //late final UserModel editor;
  final PerfilController perfilController = Get.put(PerfilController());
  @override
  void initState() {
    super.initState();
    _isLoading =
        true; // Inicializa como true para mostrar o indicador de carregamento

    perfilController.perfil(widget.userId).then((_) {
      setState(() {
        _isLoading =
            false; // Quando os dados carregarem, altera o estado de carregamento
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Perfil do editor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: _isLoading // Verifica se está carregando
          ? const Center(
              child:
                  CircularProgressIndicator(), // Mostra o indicador de carregamento
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              children: [
                //foto de perfil
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.redAccent,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(
                                perfilController.editor!.userphoto!.file),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //botão de atualizar foto
                const SizedBox(height: 10),
                //email
                BuildTextField(
                  readOnly: true,
                  initialValue: perfilController.editor?.email!,
                  icon: Icons.email,
                  label: 'Email',
                ),
                //Nome

                BuildTextField(
                  readOnly: true,
                  initialValue: perfilController.editor?.name!,
                  icon: Icons.person,
                  label: 'Nome',
                ),
                //celular
                BuildTextField(
                  readOnly: true,
                  initialValue: perfilController.editor?.phone!,
                  icon: Icons.phone,
                  label: 'Celular',
                ),
                //cpf
              ],
            ),
      //   }
    );
  }
}
