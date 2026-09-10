import 'package:flutter/material.dart';

class CatListPage extends StatelessWidget {
  const CatListPage({super.key});

  static const routeName = '/cats';
  static const routePath = '/cats';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: Text('Cat List Page')),
    );
  }
}
