// Importaciones de paquetes necesarios.
import 'package:flutter/material.dart';
import 'database/database.dart';
import 'compras_factura_page.dart';
import 'compras_reporte_page.dart';

// Define la clase para la página de Compras.
class ComprasPage extends StatelessWidget {
  // Variable para la instancia de la base de datos.
  final AppDatabase db;

  // Constructor que requiere la base de datos.
  const ComprasPage({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    // Devuelve la estructura principal de la pantalla.
    return Scaffold(
      // Barra superior de la aplicación.
      appBar: AppBar(
        title: const Text('Compras'),
        backgroundColor: Colors.indigo.shade700,
      ),
      // Cuerpo principal de la pantalla, centrado.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón para "Iniciar Factura".
            ElevatedButton.icon(
              icon: const Icon(Icons.playlist_add),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              label: const Text("Iniciar Factura", style: TextStyle(color: Colors.white),),
              onPressed: () {
                // Navega a la pantalla para crear una nueva factura de compra.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComprasFacturaPage(db: db),
                  ),
                );
              },
            ),
            // Espacio entre los botones.
            const SizedBox(height: 30),
            // Botón para "Ver Reporte de Compras".
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              label: const Text("Ver Reporte de Compras", style: TextStyle(color: Colors.white),),
              onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComprasReportePage(db: db),
                      ),
                  );
                //
              },
            ),
          ],
        ),
      ),
    );
  }
}
