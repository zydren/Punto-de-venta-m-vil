import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ComprasScannerPage extends StatefulWidget {
  const ComprasScannerPage({super.key});

  @override
  State<ComprasScannerPage> createState() => _ComprasScannerPageState();
}

class _ComprasScannerPageState extends State<ComprasScannerPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código de Barras'),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? codigo = barcodes.first.rawValue;
            if (codigo != null) {
              setState(() {
                _isProcessing = true;
              });
              // Devuelve el código a la página anterior y cierra esta.
              Navigator.of(context).pop(codigo);
            }
          }
        },
      ),
    );
  }
}
