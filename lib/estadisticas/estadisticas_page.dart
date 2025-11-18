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
          if (!snapshot.hasData || (snapshot.data!['monthlyFinancials'] as List).isEmpty) {
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

  // --- WIDGET DEL GRÁFICO DE BARRAS (CORREGIDO PARA EVITAR RANGEERROR) ---
  Widget _buildBarChartCard(List<MonthlyFinancials> data) {
    // 1. Los datos de la BD vienen del más nuevo al más viejo.
    // Se toman los 12 más recientes y se revierten para tener un orden cronológico seguro.
    final chartData = data.take(12).toList().reversed.toList();

    // 2. Se calcula el valor máximo para el eje Y.
    // Se usa 1000.0 para que la variable siempre sea double y evitar errores de tipo.
    final maxY = chartData.isEmpty
        ? 1000.0
        : chartData.map((e) => e.totalSales > e.totalPurchases ? e.totalSales : e.totalPurchases).reduce((a, b) => a > b ? a : b) * 1.2;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
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
                  maxY: maxY,
                  // 3. Se generan las barras usando el ÍNDICE de la lista ordenada.
                  // Esto es seguro y nunca dará un RangeError.
                  barGroups: List.generate(chartData.length, (index) {
                    final item = chartData[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(toY: item.totalSales, color: Colors.green, width: 15.0, borderRadius: const BorderRadius.all(Radius.circular(4))),
                        BarChartRodData(toY: item.totalPurchases, color: Colors.red, width: 15.0, borderRadius: const BorderRadius.all(Radius.circular(4))),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    // --- EJE Y (IZQUIERDA): CORREGIDO PARA EVITAR SOLAPAMIENTO ---
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45.0,
                        getTitlesWidget: (value, meta) {
                          // No se dibuja la última etiqueta para que no se solape.
                          if (value == meta.max) {
                            return Container();
                          }
                          // Se usa un formato compacto para números grandes.
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              NumberFormat.compact().format(value),
                              style: const TextStyle(fontSize: 10, color: Colors.black54),
                            ),
                          );
                        },
                      ),
                    ),
                    // --- EJE X (ABAJO): CORREGIDO PARA EVITAR RANGEERROR ---
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Se usa el ÍNDICE (value) para buscar de forma segura en la lista ordenada.
                          final month = chartData[value.toInt()].month;
                          final monthText = DateFormat.MMM('es_MX').format(DateTime(0, month));
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(monthText.substring(0,1).toUpperCase() + monthText.substring(1)),
                          );
                        },
                        reservedSize: 30.0,
                      ),
                    ),
                    // Se ocultan los ejes que no se usan.
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
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

    if (data.isEmpty) {
        return const SizedBox.shrink();
    }

    final totalAllSuppliers = data.fold(0.0, (sum, e) => sum + e.totalSales);

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
                      title: totalAllSuppliers > 0 ? '${(item.totalSales / totalAllSuppliers * 100).toStringAsFixed(0)}%' : '0%',
                      radius: 80.0,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                    );
                  }),
                  sectionsSpace: 4.0,
                  centerSpaceRadius: 40.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(data.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(width: 12.0, height: 12.0, color: pieColors[i % pieColors.length]),
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
