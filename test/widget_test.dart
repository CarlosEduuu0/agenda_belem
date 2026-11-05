import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agenda_belem/data/eventos_data.dart';
import 'package:agenda_belem/models/evento.dart';
import 'package:agenda_belem/screens/home_screen.dart';
import 'package:agenda_belem/services/eventos_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    EventosRepository.recebidos.value = const [];
  });

  testWidgets('Home lista os eventos e o toque abre os detalhes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    for (final e in eventos) {
      expect(find.text(e.titulo), findsOneWidget);
    }

    await tester.tap(find.text(eventos.first.titulo));
    await tester.pumpAndSettle();
    expect(find.text(eventos.first.local), findsOneWidget);
  });

  test('buscarEventoPorId encontra o evento certo e ignora ids inválidos', () {
    expect(buscarEventoPorId(1)?.titulo, 'Festival de Carimbó');
    expect(buscarEventoPorId(999), isNull);
  });

  test('Evento converte para JSON e volta sem perder dados', () {
    const e = Evento(
      id: 7,
      titulo: 't',
      resumo: 'r',
      descricao: 'd',
      local: 'l',
      data: 'x',
      imagemUrl: 'https://exemplo.com/a.jpg',
      messageId: 'm1',
      recebido: true,
    );
    final volta = Evento.fromJson(e.toJson());
    expect(volta.id, 7);
    expect(volta.imagemUrl, 'https://exemplo.com/a.jpg');
    expect(volta.messageId, 'm1');
    expect(volta.recebido, isTrue);
  });

  test('Mensagem sem evento_id vira um evento novo (sem duplicar)', () async {
    final msg = RemoteMessage(
      messageId: 'abc',
      notification: RemoteNotification(title: 'Show na Estação', body: 'Hoje!'),
      data: {'local': 'Estação das Docas'},
    );

    final criado = await EventosRepository.registrarMensagem(msg);
    expect(criado?.titulo, 'Show na Estação');
    expect(criado?.local, 'Estação das Docas');
    expect(criado?.recebido, isTrue);

    // Mesma mensagem de novo: não cria duplicado.
    await EventosRepository.registrarMensagem(msg);
    expect(EventosRepository.recebidos.value.length, 1);
  });

  test('Mensagem com evento_id existente aponta para o evento, sem criar',
      () async {
    final msg = RemoteMessage(
      messageId: 'def',
      notification: RemoteNotification(title: 'Carimbó', body: 'Sábado'),
      data: {'evento_id': '1'},
    );
    final e = await EventosRepository.registrarMensagem(msg);
    expect(e?.id, 1);
    expect(EventosRepository.recebidos.value, isEmpty);
  });
}
