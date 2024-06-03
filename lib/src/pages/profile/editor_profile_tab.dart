import 'package:brasiltoon/src/models/follow_editor_models.dart';
import 'package:brasiltoon/src/pages/common_widgets/build_text_field.dart';
import 'package:brasiltoon/src/pages/editor_perfil/controller/perfil_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilTab extends StatefulWidget {
  final String userId;
  // final bool follow;
  const PerfilTab({
    required this.userId,
    // required this.follow,
    super.key,
  });

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  final PerfilController perfilController = Get.put(PerfilController());
  final FollowEditorModel followEditorModel = Get.put(FollowEditorModel());
  late bool follow;

  @override
  void initState() {
    super.initState();
    perfilController.perfil(widget.userId);
    _checkIsFollow();
    perfilController.abstractId(widget.userId);
  }

  Future<void> _checkIsFollow() async {
    await perfilController.checkIfFollowing(widget.userId);
    setState(() {
      follow = perfilController.isFollowing.value;
    });
  }

  @override
  void didUpdateWidget(PerfilTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != oldWidget) {
      perfilController.checkIfFollowing(widget.userId);
      perfilController.abstractId(widget.userId);
    }
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
      body: Obx(() {
        if (perfilController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          children: [
            // Foto de perfil
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
                            perfilController.editor?.userphoto?.file ?? ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Email
            BuildTextField(
              readOnly: true,
              initialValue: perfilController.editor?.email ?? '',
              icon: Icons.email,
              label: 'Email',
            ),
            // Nome
            BuildTextField(
              readOnly: true,
              initialValue: perfilController.editor?.name ?? '',
              icon: Icons.person,
              label: 'Nome',
            ),
            // Celular
            BuildTextField(
              readOnly: true,
              initialValue: perfilController.editor?.phone ?? '',
              icon: Icons.phone,
              label: 'Celular',
            ),
            const SizedBox(height: 20),
            // Botão de seguir/deixar de seguir
            ElevatedButton(
              onPressed: () async {
                if (follow) {
                  await perfilController.unFollow(perfilController.followedId!);
                } else {
                  await perfilController.follow(widget.userId);
                }

                // Atualiza os dados após seguir/deixar de seguir
                perfilController.abstractId(widget.userId);

                setState(() {
                  follow = !follow;
                });
              },
              child: Text(follow ? 'Deixar de seguir' : 'Seguir'),
            ),
          ],
        );
      }),
    );
  }
}
