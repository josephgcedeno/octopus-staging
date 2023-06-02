import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  const ItemList({
    required this.itemList,
    Key? key,
  }) : super(key: key);

  final List<Widget> itemList;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
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
      height: height * 0.15,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: <Widget>[
            for (int i = 0; i < widget.itemList.length; i++)
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: widget.itemList[i],
              )
          ],
        ),
      ),
    );
  }
}
