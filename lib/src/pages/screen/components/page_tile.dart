import 'package:brasiltoon/src/constants/border_radius.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';

import 'package:flutter/material.dart';

class PageTile extends StatefulWidget {
  final String chapterId;
  final int index;
  const PageTile({
    Key? key,
    required this.chapterId,
    required this.page,
    required this.index,
    // required this.chapter,
  }) : super(key: key);
  final PagesChapterItemModel page;
  // final ChapterItemModel chapter;
  @override
  State<PageTile> createState() => _PageTileState();
}

class _PageTileState extends State<PageTile> {
  final GlobalKey imageGk = GlobalKey();
  late bool isLoading = true;
/*    @override
   void initState() {
    super.initState();
    // Aqui você pode adicionar a lógica para simular um carregamento, por exemplo, com um Future.delayed.
    // Vou adicionar um atraso de 2 segundos para simular o carregamento do conteúdo da página.
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        isLoading =
            false; // Quando o conteúdo da página estiver carregado, alteramos o estado para false.
      });
    });
  }*/
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Stack(
        children: [
          Image.network(
            widget.page.page,
            key: imageGk,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.none,
                child: Text(
                  '${widget.index}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
