import 'package:flutter/material.dart';
import 'inicio.dart';
import 'productos/inventario.dart';
import 'proveedores.dart';
import 'compras_factura_page.dart';
import 'compras_page.dart';
import 'database/database.dart';

final AppDatabase db = AppDatabase();


// Función que retorna la barra inferior
Widget bottomNavBar(BuildContext context, {required String currentPage}) {
  return BottomAppBar(
    color: Colors.indigo.shade700,
    child: Row(
      children: [
        // --- Facturas ---
        Expanded(
          child: InkWell(
            onTap: () {
              if (currentPage != "Facturas") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Inicio()),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, color: Colors.white),
                Text("Facturas", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),

        VerticalDivider(width: 1, thickness: 1, color: Colors.white24),

        // --- Inventario ---
        Expanded(
          child: InkWell(
            onTap: () {
              if (currentPage != "Inventario") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Inventario()),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory, color: Colors.white),
                Text("Inventario", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),

        VerticalDivider(width: 1, thickness: 1, color: Colors.white24),

        // --- Proveedores ---
        Expanded(
          child: InkWell(
            onTap: () {
              if (currentPage != "Proveedores") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Proveedores()),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping, color: Colors.white),
                Text("Proveedores", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),

        VerticalDivider(width: 1, thickness: 1, color: Colors.white24),

        // --- Compras (nuevo botón) ---
        Expanded(
          child: InkWell(
            onTap: () {
              if (currentPage != "Compras") {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ComprasPage(db:db)),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: Colors.white),
                Text("Compras", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

