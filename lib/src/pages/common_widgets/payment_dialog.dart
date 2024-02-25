import 'package:flutter/material.dart';
import 'package:brasiltoon/src/models/order_model.dart';
import 'package:brasiltoon/src/services/util_services.dart';

//import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

//var mp = MP.fromAccessToken(
//   "TEST-3245657067712792-011116-29e91066ea43bc5d79d4746dbe51ef13-232371830");

class PaymentDialog extends StatelessWidget {
  final OrderModel order;

  PaymentDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Pagamento ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                // Vencimento
                Text(
                  'Vencimento: ${utilsServices.formatDateTime(order.overdueDateTime)}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                // Total
                Text(
                  'Total: ${utilsServices.priceToCurrency(order.total)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Botão de Pagamento
                ElevatedButton(
                  onPressed: () async {
                    String paymentUrl = order.paymentUrl;
                    Uri uri = Uri.parse(
                        paymentUrl); // Obtenha a URL de pagamento do seu modelo de pedido
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      throw 'Não foi possível abrir $paymentUrl';
                    }
                  },
                  child: const Text('Pagar'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
