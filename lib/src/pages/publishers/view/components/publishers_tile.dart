import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/constants/border_radius.dart';
import 'package:brasiltoon/src/pages/common_widgets/card_widgest.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
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
  final editingControler = Get.find<EditingController>();

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
          child: CustomCardWidget(
            imageUrl: widget.publishersItem.imgUrl!.file,
            itemName: widget.publishersItem.itemName,
          ),
/*Card(
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
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.publishersItem.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //categoria
                ],
              ),
            ),
          ),*/
        ),
        //botão excluir
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () async {
              bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                  context,
                  'Esta ação ira excluir totalmente sua historia esta certo de que quér fazer isto?',
                  'sim',
                  'não');
              if (result ?? false) {
                await controller.removeItemOfEditor(
                  productId: widget.publishersItem.id,
                );
              } else {
                ultilsServices.showToast(
                  message: 'Atualização não concluida',
                );
              }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        //botão editar
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () async {
              /*  bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                  context,
                  'Sera usado moedas de sua carteira Brasiltoon para as proximas ações',
                  'continuar ?',
                  'sair');
              if (result ?? false) {*/
              Get.to(() => EditingCapeTab(
                    productId:
                        widget.publishersItem.id, // Passa o ID do produto
                    item: widget.publishersItem,
                    category: controller.currentCategory!.id,
                  ));
              //   }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: CustomColors.customSwatchColor,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
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
}
