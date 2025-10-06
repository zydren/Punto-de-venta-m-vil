import 'package:flutter/material.dart';
import 'barr.dart'; // Funcion de barra inferior

class Proveedores extends StatelessWidget {
  const Proveedores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Bienvenido al Inicio",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context, currentPage: "Proveedores"), // llamamos a la barra desde barr
    );
  }
}
