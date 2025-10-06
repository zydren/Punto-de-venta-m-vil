import 'package:flutter/material.dart';
import 'barr.dart'; // Funcion de barra inferior

class Inicio extends StatelessWidget {

  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Bienvenido al Inicio",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context,
          currentPage: "Inicio"
      ), // llamamos a la barra desde barr
    );
  }
}
