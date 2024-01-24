import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/coin_models.dart';

import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';

class CoinTile extends StatefulWidget {
  final CoinModel coin;

  const CoinTile({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  State<CoinTile> createState() => _CoinTileState();
}

class _CoinTileState extends State<CoinTile> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        // Imagem
        leading: Image.network(
          widget.coin.imgUrl,
          height: 60,
          width: 60,
        ),

        // Titulo
        title: Text(
          widget.coin.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        // Total

        // Quantidade
      ),
    );
  }
}
