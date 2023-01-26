import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({required this.isShowProject, Key? key}) : super(key: key);

  final bool isShowProject;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final List<String> projects = <String>[
      'Project Octopus',
      'NFTDeals-blocsport1',
      'FrontRx',
      'Metapad',
      'CoinMode'
    ];

    final List<String> status = <String>[
      'Done',
      'Doing',
      'Blocked',
    ];

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
            if (isShowProject)
              for (int i = 0; i < projects.length; i++)
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(projects[i]),
                )
            else
              for (int i = 0; i < status.length; i++)
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(status[i]),
                )
          ],
        ),
      ),
    );
  }
}
