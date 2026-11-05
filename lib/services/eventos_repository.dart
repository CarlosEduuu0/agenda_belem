import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/eventos_data.dart';
import '../models/evento.dart';

/// Guarda no aparelho os eventos criados a partir de notificações.
///
/// Funciona também com o app em segundo plano/encerrado: o handler de
/// background roda em outro isolate e grava aqui; o app principal recarrega
/// a lista ao abrir ou voltar para o primeiro plano.
class EventosRepository {
  EventosRepository._();

  static const _chave = 'eventos_recebidos';

  /// Eventos recebidos por notificação (mais recente primeiro).
  static final ValueNotifier<List<Evento>> recebidos =
      ValueNotifier<List<Evento>>(const []);

  static Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // pega o que o isolate de background gravou
    recebidos.value = _ler(prefs);
  }

  static List<Evento> _ler(SharedPreferences prefs) {
    final brutos = prefs.getStringList(_chave) ?? const <String>[];
    final lista = <Evento>[];
    for (final s in brutos) {
      try {
        lista.add(Evento.fromJson(jsonDecode(s) as Map<String, dynamic>));
      } catch (e) {
        debugPrint('Evento salvo inválido ignorado: $e');
      }
    }
    return lista;
  }

  static String _dois(int n) => n.toString().padLeft(2, '0');

  /// Transforma a mensagem em evento e devolve o evento correspondente.
  ///
  /// - Mensagem com `evento_id` de um evento que já existe (ex.: lembrete do
  ///   Festival de Carimbó): não cria duplicado, devolve o evento existente.
  /// - Qualquer outra mensagem: cria um evento novo e salva.
  /// - Dados opcionais na mensagem: `local`, `data`, `descricao`, `imagem`.
  static Future<Evento?> registrarMensagem(RemoteMessage m) async {
    final idExistente = int.tryParse(m.data['evento_id']?.toString() ?? '');
    if (idExistente != null) {
      final fixo = buscarEventoPorId(idExistente);
      if (fixo != null) return fixo;
    }

    final n = m.notification;
    final titulo = (n?.title ?? m.data['titulo']?.toString() ?? '').trim();
    final corpo = (n?.body ?? m.data['mensagem']?.toString() ?? '').trim();
    if (titulo.isEmpty && corpo.isEmpty) return null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final lista = _ler(prefs);

    // Mesma mensagem já registrada (ex.: salva em background e depois tocada).
    final msgId = m.messageId;
    if (msgId != null) {
      for (final e in lista) {
        if (e.messageId == msgId) return e;
      }
    }

    final agora = DateTime.now();
    final recebidoEm = 'Recebido em ${_dois(agora.day)}/${_dois(agora.month)} '
        'às ${_dois(agora.hour)}:${_dois(agora.minute)}';

    final evento = Evento(
      id: agora.millisecondsSinceEpoch,
      titulo: titulo.isEmpty ? 'Novo evento' : titulo,
      resumo: corpo.isEmpty ? 'Toque para ver os detalhes.' : corpo,
      descricao: m.data['descricao']?.toString() ??
          (corpo.isEmpty ? titulo : corpo),
      local: m.data['local']?.toString() ?? 'Belém',
      data: m.data['data']?.toString() ?? recebidoEm,
      imagemUrl: n?.android?.imageUrl ?? m.data['imagem']?.toString(),
      messageId: msgId,
      recebido: true,
    );

    lista.insert(0, evento);
    await prefs.setStringList(
      _chave,
      lista.map((e) => jsonEncode(e.toJson())).toList(),
    );
    recebidos.value = lista;
    return evento;
  }
}
