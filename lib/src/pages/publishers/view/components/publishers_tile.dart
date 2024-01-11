import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/editi_cover_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/publishers/controller/publishers_contoller.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/product_chapter.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class PublishersTile extends StatefulWidget {
  final ItemModel publishersItem;
  const PublishersTile({
    super.key,
    required this.publishersItem,
  });

  @override
  State<PublishersTile> createState() => _PublishersTileState();
}

class _PublishersTileState extends State<PublishersTile> {
  final GlobalKey imageGk = GlobalKey();
  final UtilsServices ultilsServices = UtilsServices();
  final controller = Get.find<PublisherController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ProductChapter(
                  productId: widget.publishersItem.id, // Passa o ID do produto
                  item: widget.publishersItem,
                ));
          },
          child: Card(
            elevation: 3,
            shadowColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //capat
                  GetBuilder<PublisherController>(
                    builder: (controller) {
                      return Expanded(
                        child: Image.network(
                          widget.publishersItem.imgUrl,
                          //  key: imageGk,
                        ),
                      );
                    },
                  ),
                  //Nome
                  Text(
                    widget.publishersItem.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //categoria
                ],
              ),
            ),
          ),
        ),
        //botão editar
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              Get.to(() => EditingCapeTab(
                    productId:
                        widget.publishersItem.id, // Passa o ID do produto
                    item: widget.publishersItem,
                    category: controller.currentCategory!.id,
                  ));
            },
            child: Container(
              height: 40,
              width: 35,
              decoration: BoxDecoration(
                color: CustomColors.customSwatchColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Icon(
                PhosphorIcons.pencil,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ), // OBS CRIAR UMA FUNÇÃO PARA EDIÇÃO DA HISTORIA
      ],
    );
  }

  /* Future<bool?> showOrderComfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Comfirmação'),
          content: const Text('Deseja realmente editar sua historia'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('não'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('sim'),
            ),
          ],
        );
      },
    );
  }*/
}
