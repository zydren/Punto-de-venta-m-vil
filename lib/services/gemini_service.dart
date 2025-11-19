import 'package:google_generative_ai/google_generative_ai.dart';
import '../compras/sugerencias_compra_page.dart'; 

class GeminiService {
  // API Key validada
  static const String _apiKey = 'AIzaSyDOk8Mqy7muLc9A0ILTT7Iwyc9qwLXpdnE';
  late final GenerativeModel _model;

  GeminiService() {
    // SEGÚN TU CONSULTA A LA API:
    // Tu cuenta tiene acceso a modelos "2.5". Usaremos el nombre exacto que apareció en tu lista.
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: _apiKey.trim(),
    );
  }

  Future<String> analizarInventario(List<ProductoSugerencia> sugerencias) async {
    if (sugerencias.isEmpty) {
      return "No hay datos suficientes para realizar un análisis.";
    }

    final buffer = StringBuffer();
    buffer.writeln("Eres un experto Gerente de Logística.");
    buffer.writeln("Analiza este inventario crítico y sugiere compras:");
    buffer.writeln("\n--- DATOS ---");

    for (final item in sugerencias) {
      buffer.writeln("- ${item.producto.nombre}: Stock ${item.producto.cantidad}. Sugerencia: Comprar ${item.cantidadSugerida}");
    }

    buffer.writeln("\nRespuesta en Markdown conciso.");

    try {
      final content = [Content.text(buffer.toString())];
      final response = await _model.generateContent(content);
      return response.text ?? "Respuesta vacía de la IA.";
    } catch (e) {
      print("ERROR GEMINI: $e");
      return "Error técnico:\n$e\n\nModelo usado: gemini-2.5-flash";
    }
  }
}
