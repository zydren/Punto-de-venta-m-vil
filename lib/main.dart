import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 1. IMPORTA LA LIBRERÍA
import 'inicio.dart';

// 2. SE CONVIERTE MAIN EN ASÍNCRONO
void main() async {
  // Se asegura de que los componentes de Flutter estén listos.
  WidgetsFlutterBinding.ensureInitialized();

  // 3. LA SOLUCIÓN: Carga los datos para el formato de fecha en español (México).
  await initializeDateFormatting('es_MX', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punto de Venta',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // --- CORRECCIÓN: Se cambia CardTheme por CardThemeData ---
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const Inicio(),
      debugShowCheckedModeBanner: false,
    );
  }
}
