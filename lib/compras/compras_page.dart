import 'package:flutter/material.dart';
import '../database/database.dart';
import 'compras_factura_page.dart';
import 'compras_reporte_page.dart';
import 'sugerencias_compra_page.dart'; // Importar la nueva página
import '../barr.dart';

class ComprasPage extends StatelessWidget {
  final AppDatabase db;

  const ComprasPage({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.green.shade700;
    final Color secondaryColor = Colors.orange.shade700;
    final Color tertiaryColor = Colors.blue.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Gestión de Compras',
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
                "Opciones de Compra",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Registra facturas, consulta el historial o genera sugerencias.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // --- NUEVO: Tarjeta de Acción para "Sugerencias de Compra" ---
              _buildActionCard(
                context: context,
                icon: Icons.lightbulb_outline,
                title: "Sugerencias de Compra",
                subtitle: "Analiza las ventas para predecir qué productos reponer.",
                color: tertiaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SugerenciasCompraPage(db: db)),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildActionCard(
                context: context,
                icon: Icons.note_add_outlined,
                title: "Iniciar Factura de Compra",
                subtitle: "Registra los productos recibidos de un proveedor.",
                color: primaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComprasFacturaPage(db: db)),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildActionCard(
                context: context,
                icon: Icons.history_edu_outlined,
                title: "Reporte de Compras",
                subtitle: "Consulta el historial de todas las facturas registradas.",
                color: secondaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComprasReportePage(db: db)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context, currentPage: "Compras"),
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
