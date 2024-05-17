import 'package:flutter/material.dart';

class CustomCardWidget extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final GlobalKey? imageGk;
  // final GlobalKey? imageGk;
  // Adicione outros atributos conforme necessário

  const CustomCardWidget({
    Key? key,
    required this.imageUrl,
    required this.itemName,
    this.imageGk,
    //this.imageGk,
    // Adicione outros atributos conforme necessário
  }) : super(key: key);

  @override
  State<CustomCardWidget> createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Material(
                elevation: 6,
                color: Colors.transparent, // Make material transparent
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.grey.shade300,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white54,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10, // Adjust as necessary
                        spreadRadius: 2, // Adjust as necessary
                        offset: const Offset(0, 0), // Adjust as necessary
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imageUrl,
                      key: widget.imageGk,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.itemName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
