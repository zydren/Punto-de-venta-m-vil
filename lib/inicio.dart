import 'package:flutter/material.dart';
import 'barr.dart'; // Funcion de barra inferior e instancia de DB
import 'ventas/ventas_page.dart';
import 'ventas/ventas_reporte_page.dart';
import 'estadisticas/estadisticas_page.dart'; // Importa la nueva página de estadísticas

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.indigo.shade700;
    final Color secondaryColor = Colors.teal.shade400;
    // Color para la nueva tarjeta de estadísticas
    final Color statsColor = Colors.orange.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Panel Principal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E), // Indigo 900
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selecciona una acción para comenzar a gestionar tu negocio.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              
              _buildActionCard(
                context: context,
                icon: Icons.point_of_sale_outlined,
                title: "Realizar Venta",
                subtitle: "Inicia una nueva transacción y escanea productos.",
                color: primaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VentasPage(db: db)),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              _buildActionCard(
                context: context,
                icon: Icons.receipt_long_outlined,
                title: "Reporte de Ventas",
                subtitle: "Consulta el historial de tickets y gestiona las ventas.",
                color: secondaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VentasReportePage(db: db)),
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- MODIFICACIÓN: Nueva tarjeta de acción para Estadísticas ---
              _buildActionCard(
                context: context,
                icon: Icons.bar_chart_outlined,
                title: "Estadísticas y Finanzas",
                subtitle: "Analiza el rendimiento de tus ventas y gastos.",
                color: statsColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EstadisticasPage(db: db)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context, currentPage: "Inicio"),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
