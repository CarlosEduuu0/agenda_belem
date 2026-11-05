import 'package:flutter/material.dart';

import '../models/evento.dart';

class DetalhesScreen extends StatelessWidget {
  final Evento evento;
  const DetalhesScreen({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    final imagem = evento.imagemUrl;
    return Scaffold(
      appBar: AppBar(title: Text(evento.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagem != null && imagem.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagem,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(evento.titulo, style: tema.headlineSmall),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.schedule, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(evento.data)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.place, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(evento.local)),
            ]),
            const SizedBox(height: 20),
            Text(evento.descricao, style: tema.bodyLarge),
          ],
        ),
      ),
    );
  }
}
