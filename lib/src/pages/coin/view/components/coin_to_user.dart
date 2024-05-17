import 'package:brasiltoon/src/models/coin_of_user_models.dart';

import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';

class CoinOfUserTile extends StatefulWidget {
  final CoinOfUserModel coin;

  const CoinOfUserTile({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  State<CoinOfUserTile> createState() => _CoinOfUserTileState();
}

class _CoinOfUserTileState extends State<CoinOfUserTile> {
  final GlobalKey imageGk = GlobalKey();
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    String titleText =
        widget.coin.coins != 0 ? ' = ${widget.coin.coins.toString()}' : ' = 0';

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        // Imagem
        leading: Image.asset(
          'assets/moeda/gold-coin.png',
          key: imageGk,
          height: 40,
          width: 40,
        ),
        // Titulo

        title: Text(
          titleText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
