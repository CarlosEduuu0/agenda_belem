import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart'; // gerado pelo comando `flutterfire configure`
import 'screens/home_screen.dart';
import 'services/eventos_repository.dart';
import 'services/notificacao_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await EventosRepository.carregar();
  runApp(const AgendaBelemApp());
}

class AgendaBelemApp extends StatefulWidget {
  const AgendaBelemApp({super.key});

  @override
  State<AgendaBelemApp> createState() => _AgendaBelemAppState();
}

class _AgendaBelemAppState extends State<AgendaBelemApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificacaoService.instance.inicializar();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Ao voltar do segundo plano, recarrega os eventos que o handler de
  /// background possa ter salvo enquanto o app estava fora da tela.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      EventosRepository.carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final servico = NotificacaoService.instance;
    return MaterialApp(
      title: 'Agenda Belém',
      debugShowCheckedModeBanner: false,
      navigatorKey: servico.navigatorKey,
      scaffoldMessengerKey: servico.messengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
