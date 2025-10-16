import 'package:flutter/material.dart';
import 'database/database.dart';
import 'compras_factura_page.dart'; // página que haremos después

class ComprasPage extends StatelessWidget {
  final AppDatabase db;

  const ComprasPage({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.playlist_add),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              label: const Text("Iniciar Factura", style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComprasFacturaPage(db: db),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              label: const Text("Ver Reporte de Compras", style: TextStyle(color: Colors.white),),
              onPressed: () {
                // (en el futuro abriremos el reporte)
              },
            ),
          ],
        ),
      ),
    );
  }
}
