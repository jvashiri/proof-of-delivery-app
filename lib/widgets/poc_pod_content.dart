import 'package:flutter/material.dart';

class PocPodContent extends StatelessWidget {
  final String content;

  PocPodContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(content),
    );
  }
}
