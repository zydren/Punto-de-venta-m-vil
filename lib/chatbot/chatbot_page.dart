import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../database/database.dart';
import '../services/gemini_service.dart';

class ChatbotPage extends StatefulWidget {
  final AppDatabase db;

  const ChatbotPage({super.key, required this.db});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Lista de mensajes: {role: 'user'|'ai', text: '...'}
  final List<Map<String, String>> _messages = [];
  bool _isLoading = true; // Cargando contexto inicial
  bool _isSending = false; // Enviando mensaje

  @override
  void initState() {
    super.initState();
    _inicializarChat();
  }

  Future<void> _inicializarChat() async {
    try {
      await _geminiService.iniciarChatConBaseDeDatos(widget.db);
      setState(() {
        _messages.add({
          'role': 'ai', 
          'text': '¡Hola! Soy tu Asistente de Negocios. 🤖\n\nHe analizado tu base de datos y estoy listo. Pregúntame sobre:\n\n* 📦 Stock de productos\n* 💰 Ventas y ganancias\n* 🚛 Proveedores\n* 📊 Resúmenes mensuales'
        });
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'text': 'Error al cargar los datos: $e'});
        _isLoading = false;
      });
    }
  }

  Future<void> _enviarMensaje() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isSending = true;
      _messages.add({'role': 'ai', 'text': ''}); // Placeholder para la respuesta
    });
    _scrollToBottom();

    try {
      String fullResponse = "";
      // Usamos stream para efecto de "escribiendo" en tiempo real
      await for (final chunk in _geminiService.enviarMensajeStream(text)) {
        fullResponse += chunk;
        setState(() {
          _messages.last['text'] = fullResponse;
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        _messages.last['text'] = "Lo siento, ocurrió un error: $e";
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.smart_toy_outlined, color: Colors.indigo),
            SizedBox(width: 10),
            Text("Asistente Virtual", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- ÁREA DE CHAT ---
          Expanded(
            child: _isLoading 
              ? const Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Analizando tu negocio...", style: TextStyle(color: Colors.grey)),
                  ],
                ))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['role'] == 'user';
                    
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.indigo : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                          ],
                        ),
                        child: isUser 
                          ? Text(msg['text']!, style: const TextStyle(color: Colors.white, fontSize: 16))
                          : MarkdownBody(
                              data: msg['text']!,
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(fontSize: 15, color: Colors.black87),
                                listBullet: const TextStyle(color: Colors.indigo),
                              ),
                            ),
                      ),
                    );
                  },
                ),
          ),
          
          // --- CAMPO DE TEXTO ---
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Pregunta sobre ventas, stock...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _enviarMensaje(),
                    enabled: !_isLoading && !_isSending,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: _isSending || _isLoading ? Colors.grey : Colors.indigo,
                  child: IconButton(
                    icon: _isSending 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: (_isLoading || _isSending) ? null : _enviarMensaje,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
