import 'package:flutter/material.dart';

class DSRScreen extends StatefulWidget {
  const DSRScreen({Key? key}) : super(key: key);

  static const String routeName = '/dsr';

  @override
  State<DSRScreen> createState() => _DSRScreenState();
}

class _DSRScreenState extends State<DSRScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('DSR Screen'));
  }
}
