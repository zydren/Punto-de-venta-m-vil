import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../compras/sugerencias_compra_page.dart';

class GeminiService {
  // API Key validada
  static const String _apiKey = 'AIzaSyDOk8Mqy7muLc9A0ILTT7Iwyc9qwLXpdnE';
  late final GenerativeModel _model;
  ChatSession? _chatSession; // Mantiene la memoria de la conversación

  GeminiService() {
    // Modelo validado con tu cuenta: gemini-2.5-flash
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey.trim(),
      generationConfig: GenerationConfig(
        temperature: 0.4, // Más preciso, menos creativo
      )
    );
  }

  // --- 1. ANÁLISIS RÁPIDO DE COMPRAS (Ya existente) ---
  Future<String> analizarInventario(List<ProductoSugerencia> sugerencias) async {
    if (sugerencias.isEmpty) return "No hay datos suficientes.";
    
    final buffer = StringBuffer();
    buffer.writeln("Eres un experto Gerente de Logística. Analiza estos datos:");
    for (final item in sugerencias) {
      buffer.writeln("- ${item.producto.nombre}: Stock ${item.producto.cantidad}. Sugerir: ${item.cantidadSugerida}");
    }
    buffer.writeln("\nRespuesta en Markdown conciso.");

    try {
      final response = await _model.generateContent([Content.text(buffer.toString())]);
      return response.text ?? "Sin respuesta.";
    } catch (e) {
      return "Error: $e";
    }
  }

  // --- 2. INICIAR CHAT CON CONTEXTO COMPLETO ---
  Future<void> iniciarChatConBaseDeDatos(AppDatabase db) async {
    // A. Recopilar TODA la información relevante del negocio
    final productos = await db.select(db.productos).get();
    final proveedores = await db.select(db.proveedores).get();
    final finanzas = await db.getMonthlyFinancials(); // Tu método existente
    final topProveedores = await db.getTopSuppliers(); // Tu método existente

    // B. Construir el "Prompt Maestro" (Data Dump)
    final systemPrompt = StringBuffer();
    systemPrompt.writeln("Actúa como el Asistente Inteligente de este negocio. Tienes acceso total a la base de datos.");
    systemPrompt.writeln("Usa la siguiente información para responder las preguntas del usuario con precisión.");
    systemPrompt.writeln("Si no sabes algo, di que no tienes esa información en la base de datos.");

    systemPrompt.writeln("\n--- INVENTARIO ACTUAL ---");
    for (var p in productos) {
      systemPrompt.writeln("ID: ${p.id} | Nombre: ${p.nombre} | Stock: ${p.cantidad} | Costo: \$${p.precioCompra} | Venta: \$${p.precioVenta} | Prov: ${p.proveedor}");
    }

    systemPrompt.writeln("\n--- PROVEEDORES REGISTRADOS ---");
    for (var p in proveedores) {
      systemPrompt.writeln("- ${p.nombre} (Tel: ${p.numero ?? 'N/A'})");
    }

    systemPrompt.writeln("\n--- RESUMEN FINANCIERO (Últimos meses) ---");
    for (var f in finanzas) {
      systemPrompt.writeln("Fecha: ${f.month}/${f.year} | Ventas: \$${f.totalSales.toStringAsFixed(2)} | Compras: \$${f.totalPurchases.toStringAsFixed(2)}");
    }

    systemPrompt.writeln("\n--- TOP PROVEEDORES POR VOLUMEN ---");
    for (var tp in topProveedores) {
      systemPrompt.writeln("- ${tp.supplierName}: \$${tp.totalSales.toStringAsFixed(2)} vendidos");
    }
    
    systemPrompt.writeln("\n--- FIN DE DATOS ---");
    systemPrompt.writeln("Responde siempre en español, de forma amable y profesional. Usa Markdown para tablas o listas.");

    // C. Iniciar la sesión de chat con este historial inicial
    _chatSession = _model.startChat(history: [
      Content.text(systemPrompt.toString()), // Primer mensaje (Contexto invisible)
      Content.model([TextPart("Entendido. Tengo los datos del negocio. ¿En qué puedo ayudarte hoy?")]), // Respuesta simulada de la IA
    ]);
  }

  // --- 3. ENVIAR MENSAJE AL CHAT ---
  Stream<String> enviarMensajeStream(String mensajeUsuario) async* {
    if (_chatSession == null) {
      yield "Error: El chat no ha sido inicializado con los datos.";
      return;
    }

    try {
      final response = _chatSession!.sendMessageStream(Content.text(mensajeUsuario));
      await for (final chunk in response) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      yield "Error al conectar con la IA: $e";
    }
  }
}
