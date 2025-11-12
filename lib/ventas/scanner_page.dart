import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // --- CORRECCIÓN: Se añade una bandera para controlar el procesamiento ---
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código'),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: MobileScanner(
        // --- CORRECCIÓN: Lógica robusta para onDetect ---
        onDetect: (capture) {
          // Si ya se está procesando un código, ignora los siguientes.
          if (_isProcessing) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? codigo = barcodes.first.rawValue;
            if (codigo != null) {
              // Se activa la bandera para no volver a entrar aquí.
              setState(() {
                _isProcessing = true;
              });
              // Se devuelve el código y se cierra la pantalla UNA SOLA VEZ.
              Navigator.of(context).pop(codigo);
            }
          }
        },
      ),
    );
  }
}
