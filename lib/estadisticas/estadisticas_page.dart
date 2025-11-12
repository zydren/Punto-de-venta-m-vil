import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../barr.dart';

class EstadisticasPage extends StatefulWidget {
  final AppDatabase db;

  const EstadisticasPage({super.key, required this.db});

  @override
  State<EstadisticasPage> createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<Map<String, dynamic>> _loadStats() async {
    final monthlyFinancials = await widget.db.getMonthlyFinancials();
    final topSuppliers = await widget.db.getTopSuppliers();
    return {
      'monthlyFinancials': monthlyFinancials,
      'topSuppliers': topSuppliers,
    };
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.blueGrey.shade50;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Estadísticas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error al cargar estadísticas: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!['monthlyFinancials'].isEmpty) {
            return const Center(child: Text("No hay datos suficientes para mostrar estadísticas."));
          }

          final monthlyFinancials = snapshot.data!['monthlyFinancials'] as List<MonthlyFinancials>;
          final topSuppliers = snapshot.data!['topSuppliers'] as List<SupplierSales>;

          double totalSales = monthlyFinancials.fold(0.0, (sum, item) => sum + item.totalSales);
          double totalPurchases = monthlyFinancials.fold(0.0, (sum, item) => sum + item.totalPurchases);
          double netProfit = totalSales - totalPurchases;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildKpiSection(totalSales, totalPurchases, netProfit),
              const SizedBox(height: 24),
              _buildBarChartCard(monthlyFinancials),
              const SizedBox(height: 24),
              _buildPieChartCard(topSuppliers),
            ],
          );
        },
      ),
      bottomNavigationBar: bottomNavBar(context, currentPage: "Inicio"),
    );
  }

  Widget _buildKpiSection(double totalSales, double totalPurchases, double netProfit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Resumen Financiero", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildKpiCard("Ingresos Totales", totalSales, Colors.green, Icons.arrow_upward)),
            const SizedBox(width: 16),
            Expanded(child: _buildKpiCard("Gastos Totales", totalPurchases, Colors.red, Icons.arrow_downward)),
          ],
        ),
        const SizedBox(height: 16),
        _buildKpiCard("Ganancia Neta", netProfit, Colors.indigo, Icons.monetization_on_outlined, isFullWidth: true),
      ],
    );
  }

  // --- CORRECCIÓN: El tipo del parámetro 'color' se cambia a MaterialColor ---
  Widget _buildKpiCard(String title, double value, MaterialColor color, IconData icon, {bool isFullWidth = false}) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(value),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color.shade800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartCard(List<MonthlyFinancials> data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rendimiento Mensual", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: data.map((e) => e.totalSales > e.totalPurchases ? e.totalSales : e.totalPurchases).reduce((a, b) => a > b ? a : b) * 1.2,
                  barGroups: data.take(12).map((item) {
                    final monthIndex = item.month -1;
                    return BarChartGroupData(
                      x: monthIndex,
                      barRods: [
                        BarChartRodData(toY: item.totalSales, color: Colors.green, width: 15),
                        BarChartRodData(toY: item.totalPurchases, color: Colors.red, width: 15),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                     bottomTitles: AxisTitles(
                       sideTitles: SideTitles(
                         showTitles: true,
                         getTitlesWidget: (value, meta) {
                            final month = data[value.toInt()].month;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(DateFormat.MMM().format(DateTime(0, month))), // 'Ene', 'Feb'
                            );
                         },
                         reservedSize: 30,
                       ),
                     ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartCard(List<SupplierSales> data) {
    final List<Color> pieColors = [
      Colors.blue.shade400, Colors.red.shade400, Colors.green.shade400, 
      Colors.orange.shade400, Colors.purple.shade400
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Top 5 Proveedores (por Ventas)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: List.generate(data.length, (i) {
                    final item = data[i];
                    return PieChartSectionData(
                      color: pieColors[i % pieColors.length],
                      value: item.totalSales,
                      title: '${(item.totalSales / data.fold(0.0, (sum, e) => sum + e.totalSales) * 100).toStringAsFixed(0)}%',
                      radius: 80,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                    );
                  }),
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(data.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: pieColors[i % pieColors.length]),
                    const SizedBox(width: 8),
                    Text(data[i].supplierName, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
