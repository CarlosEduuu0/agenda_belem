# Agenda Belém — Notificações Push (Flutter + FCM)

App simples com a agenda de eventos culturais e gastronômicos de Belém.
Tela inicial (lista de eventos) + tela de detalhes. Os eventos ficam no código
(`lib/data/eventos_data.dart`); as notificações são enviadas manualmente pelo
Firebase Console (plano Spark, sem backend, sem login).

**Atividade Prática 4 — Programação para Dispositivos Móveis**

## Por que notificações?

Eventos têm data e hora. O usuário quer ser avisado de novidades, destaques e
lembretes sem precisar abrir o app.

## Como rodar

```bash
git clone https://github.com/CarlosEduuu0/agenda_belem.git
cd agenda_belem
flutter pub get
flutter run          # aparelho Android real (ou emulador com Google Play)
```

O `google-services.json` e o `firebase_options.dart` já estão no repositório.
Ao abrir, aceite a permissão de notificações. O token FCM aparece no log
(`FCM TOKEN: ...`).

## Testando os três desafios

Firebase Console > Messaging > Nova campanha > Notificações > **Enviar mensagem de teste**
(cole o token FCM). Deixe o app em segundo plano (botão Home) ao enviar.

| Desafio | Título | Texto | Imagem | Dados personalizados |
|---|---|---|---|---|
| 1 — simples | `Agenda atualizada` | `Novos eventos culturais foram adicionados em Belém.` | — | — |
| 2 — com imagem | `Feira de Gastronomia Paraense` | `Tacacá, maniçoba e açaí no domingo (15/11), na Estação das Docas.` | URL https pública (jpg/png, até ~1 MB) | — |
| 3 — navegação | `Festival de Carimbó neste sábado!` | `Dia 14, às 19h, no Mangal das Garças. Toque para ver os detalhes.` | opcional | `evento_id` = `1` |

`evento_id` aceita `1` (Festival de Carimbó), `2` (Feira de Gastronomia) ou `3` (Feira de Artesanato).
A chave deve ser exatamente `evento_id`.

Para testar o app **encerrado**: feche-o pelo gerenciador de apps (deslizar), envie a
mensagem e toque na notificação. Não use "Forçar parada", pois em alguns aparelhos isso
bloqueia o FCM até o app ser aberto de novo.

## Como funciona

- **Segundo plano / encerrado:** o sistema Android exibe a notificação (com imagem, se houver).
  Ao tocar, `onMessageOpenedApp` (segundo plano) ou `getInitialMessage` (encerrado) leem
  `evento_id` e abrem a `DetalhesScreen` (`lib/services/notificacao_service.dart`).
- **Primeiro plano:** o Android não mostra notificação automática; o app exibe um SnackBar
  com o botão "VER" (limitação conhecida; a imagem não é exibida nesse caso).
- **Canal de notificação:** `MainActivity.kt` cria o canal `agenda_belem_eventos` com
  importância alta, e o `AndroidManifest.xml` o define como padrão do FCM, para a notificação
  aparecer como pop-up. O manifest também define o ícone e a cor padrão.

## Cada mensagem vira um evento

Toda notificação recebida é guardada no aparelho (`shared_preferences`) e aparece no
topo da lista, com o ícone de sino. Funciona com o app aberto, em segundo plano e
encerrado (handler `firebaseMessagingBackgroundHandler`). Ao tocar na notificação, abre
o evento criado.

Dados opcionais em "Dados personalizados" do Console (todos opcionais):

| Chave | Efeito |
|---|---|
| `local` | Local do evento (padrão: "Belém") |
| `data` | Texto da data, ex.: `Sáb, 28 de novembro • 20h` (padrão: horário de recebimento) |
| `descricao` | Texto longo da tela de detalhes (padrão: o texto da notificação) |
| `imagem` | URL https da imagem (se não usar o campo de imagem do Console) |
| `evento_id` | `1`, `2` ou `3`: abre o evento já existente em vez de criar um novo (Desafio 3) |

A imagem do Console, quando enviada, também aparece na tela de detalhes do evento criado.

## Testes automatizados

```bash
flutter test
```
