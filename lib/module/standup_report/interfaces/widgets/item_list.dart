import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({required this.itemList, Key? key}) : super(key: key);

  final List<Widget> itemList;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: 120,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 8,
            ),
          ],
        ),
        width: width * 0.85,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < itemList.length; i++)
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: itemList[i],
              )
          ],
        ),
      ),
    );
  }
}
