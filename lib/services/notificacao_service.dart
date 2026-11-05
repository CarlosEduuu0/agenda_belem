import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../screens/detalhes_screen.dart';
import 'eventos_repository.dart';

/// Handler de mensagens com o app em segundo plano/encerrado.
/// Precisa ser função de nível superior. O Android exibe a notificação
/// sozinho; aqui só guardamos a mensagem como um evento novo.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage mensagem) async {
  await EventosRepository.registrarMensagem(mensagem);
}

/// Centraliza tudo relacionado ao FCM: permissão, token e tratamento
/// dos três estados do app (primeiro plano, segundo plano e encerrado).
class NotificacaoService {
  NotificacaoService._();
  static final NotificacaoService instance = NotificacaoService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> inicializar() async {
    final fcm = FirebaseMessaging.instance;

    // Desafio 3 — app em segundo plano: usuário toca na notificação.
    FirebaseMessaging.onMessageOpenedApp.listen(_abrirDetalhes);

    // App aberto (primeiro plano): o Android não exibe a notificação
    // sozinho, então mostramos um aviso dentro do app.
    FirebaseMessaging.onMessage.listen(_aoReceberEmPrimeiroPlano);

    // Desafio 3 — app encerrado: iniciado pelo toque na notificação.
    final inicial = await fcm.getInitialMessage();
    if (inicial != null) {
      // Espera o primeiro frame para o Navigator existir.
      await WidgetsBinding.instance.endOfFrame;
      await _abrirDetalhes(inicial);
    }

    // Android 13+ exige permissão em tempo de execução.
    await fcm.requestPermission(alert: true, badge: true, sound: true);

    // Útil para enviar "mensagem de teste" pelo Firebase Console.
    final token = await fcm.getToken();
    debugPrint('FCM TOKEN: $token');
  }

  Future<void> _aoReceberEmPrimeiroPlano(RemoteMessage mensagem) async {
    final evento = await EventosRepository.registrarMensagem(mensagem);
    final n = mensagem.notification;
    if (n == null) return;

    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 6),
          content: Text('${n.title ?? ''}\n${n.body ?? ''}'),
          action: evento != null
              ? SnackBarAction(
                  label: 'VER',
                  onPressed: () => _abrirEvento(evento),
                )
              : null,
        ),
      );
  }

  /// Toda mensagem vira (ou aponta para) um evento. Se a mensagem traz
  /// `evento_id` de um evento existente, abre esse evento (Desafio 3).
  Future<void> _abrirDetalhes(RemoteMessage mensagem) async {
    final evento = await EventosRepository.registrarMensagem(mensagem);
    if (evento == null) return;
    _abrirEvento(evento);
  }

  void _abrirEvento(Evento evento) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => DetalhesScreen(evento: evento)),
    );
  }
}
