import 'package:flutter/material.dart';
import 'inicio.dart';
import 'productos/inventario.dart';
import 'proveedores/proveedores.dart';
import 'compras/compras_factura_page.dart';
import 'compras/compras_page.dart';
// Se oculta la clase 'Proveedores' de la base de datos para evitar conflicto.
import 'database/database.dart' hide Proveedores;

final AppDatabase db = AppDatabase();

// --- Barra de Navegación Inferior Rediseñada ---
Widget bottomNavBar(BuildContext context, {required String currentPage}) {

  // Mapea los nombres de las páginas a un índice para el BottomNavigationBar
  final Map<String, int> pageIndices = {
    "Inicio": 0, // Corregido: La primera página es "Inicio"
    "Inventario": 1,
    "Proveedores": 2,
    "Compras": 3,
  };

  final int currentIndex = pageIndices[currentPage] ?? 0;

  // Navega a la página correcta al tocar un ítem
  void _onItemTapped(int index) {
    // Evita recargar la misma página
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Inicio()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Inventario()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Proveedores()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ComprasPage(db: db)));
        break;
    }
  }

  return BottomNavigationBar(
    // --- Estilo Profesional ---
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed, // Mantiene el layout consistente
    currentIndex: currentIndex,
    onTap: _onItemTapped,
    
    // Colores que combinan con el resto del diseño
    selectedItemColor: Colors.indigo.shade700,
    unselectedItemColor: Colors.grey.shade600,
    
    // Estilo de texto sutil y limpio
    selectedFontSize: 12.0,
    unselectedFontSize: 12.0,

    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        // Corregido: Icono y etiqueta para "Inicio"
        activeIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: 'Inicio',
      ),
      BottomNavigationBarItem(
        activeIcon: Icon(Icons.inventory),
        icon: Icon(Icons.inventory_outlined),
        label: 'Inventario',
      ),
      BottomNavigationBarItem(
        activeIcon: Icon(Icons.local_shipping),
        icon: Icon(Icons.local_shipping_outlined),
        label: 'Proveedores',
      ),
      BottomNavigationBarItem(
        activeIcon: Icon(Icons.shopping_cart),
        icon: Icon(Icons.shopping_cart_outlined),
        label: 'Compras',
      ),
    ],
  );
}
