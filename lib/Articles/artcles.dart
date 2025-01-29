import 'package:flutter/material.dart';

class Artcles extends StatefulWidget {
  const Artcles({super.key});

  @override
  State<Artcles> createState() => _ArtclesState();
}

class _ArtclesState extends State<Artcles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 240, 240),
      body: Center(
        child: Text(
          "We are Update as Soon as!!",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}