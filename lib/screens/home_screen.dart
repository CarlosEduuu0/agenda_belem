import 'package:flutter/material.dart';

import '../data/eventos_data.dart';
import '../models/evento.dart';
import '../services/eventos_repository.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda Belém')),
      body: ValueListenableBuilder<List<Evento>>(
        valueListenable: EventosRepository.recebidos,
        builder: (context, recebidos, _) {
          // Eventos novos (vindos de notificações) aparecem primeiro.
          final lista = [...recebidos, ...eventos];
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final e = lista[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      e.recebido ? Icons.notifications_active : Icons.event,
                    ),
                  ),
                  title: Text(e.titulo),
                  subtitle: Text(
                    '${e.resumo}\n${e.data}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetalhesScreen(evento: e),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
