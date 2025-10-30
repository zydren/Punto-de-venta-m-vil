import 'package:flutter/material.dart';
import 'barr.dart'; // Funcion de barra inferior e instancia de DB
import 'ventas/ventas_page.dart'; // Importa la nueva página de ventas
import 'ventas/ventas_reporte_page.dart'; // Importa la página de reporte de ventas

class Inicio extends StatelessWidget {

  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Colors.indigo.shade700,
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  // Se pasa la instancia de la base de datos (db) a la página de ventas.
                  MaterialPageRoute(builder: (context) => VentasPage(db: db)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                minimumSize: const Size(250, 65),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.point_of_sale, size: 28, color: Colors.white,),
              label: const Text("Realizar Venta", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VentasReportePage(db: db)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(250, 65),
                 textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.article, size: 28, color: Colors.white,),
              label: const Text("Reporte de Ventas", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavBar(context,
          currentPage: "Facturas" // La página de inicio corresponde a la sección "Facturas"
      ), // llamamos a la barra desde barr
    );
  }
}
