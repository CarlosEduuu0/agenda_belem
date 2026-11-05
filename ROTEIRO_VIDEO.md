# Roteiro do vídeo (aprox. 6–8 min)

## 1. Abertura (30 s)
"Olá, eu sou o Carlos, e este é o app **Agenda Belém**, desenvolvido em Flutter com Firebase
Cloud Messaging para a Atividade Prática 4 de Programação para Dispositivos Móveis."

## 2. Finalidade e público (45 s)
- Mostrar a tela inicial com a lista de eventos.
- "O app apresenta a agenda de eventos culturais e gastronômicos de Belém, para moradores e turistas."
- "Notificação é útil porque eventos têm data e hora: o usuário quer ser avisado de novidades,
  destaques e lembretes sem precisar abrir o app."
- Mostrar rapidamente a tela de detalhes (título, data, local, descrição).

## 3. Visão rápida do código (1 min)
- `pubspec.yaml`: `firebase_core` e `firebase_messaging`.
- `notificacao_service.dart`: permissão, `onMessageOpenedApp`, `getInitialMessage`, `onMessage`.
- `AndroidManifest.xml` + `MainActivity.kt`: canal de notificação de importância alta.
- Mostrar o projeto no Firebase Console (plano Spark) e o token FCM no log.

## 4. Desafio 1 — Notificação simples (1 min)
- **Decisão:** o evento é "agenda atualizada"; avisa que há novos eventos.
  Título: *Agenda atualizada*. Mensagem: *Novos eventos culturais foram adicionados em Belém.*
- Colocar o app em segundo plano, enviar pelo Firebase Console e mostrar a notificação no Android.

## 5. Desafio 2 — Notificação personalizada com imagem (1 min 30 s)
- **Decisão:** destacar o evento mais atrativo (Feira de Gastronomia Paraense), com uma imagem
  do conteúdo, porque a imagem desperta interesse e identifica o evento antes de abrir o app.
  Título: *Feira de Gastronomia Paraense*. Mensagem: *Tacacá, maniçoba e açaí no domingo (15/11),
  na Estação das Docas.*
- Mostrar no Console o campo de imagem com a URL, enviar com o app em segundo plano e expandir
  a notificação para mostrar a imagem.

## 6. Desafio 3 — Notificação com navegação (2 min)
- **Decisão:** lembrete do Festival de Carimbó, com o dado `evento_id = 1` identificando o
  conteúdo. Título: *Festival de Carimbó neste sábado!* Mensagem: *Dia 14, às 19h, no Mangal das
  Garças. Toque para ver os detalhes.* Mostrar no Console o campo "Dados personalizados".
- **Caso A (segundo plano):** enviar, tocar na notificação → abre a tela de detalhes do evento 1.
- **Caso B (app encerrado):** fechar o app, enviar, tocar → o app inicia já na tela de detalhes.
- Explicar no código: `onMessageOpenedApp` (caso A) e `getInitialMessage` (caso B) leem
  `evento_id` e chamam `buscarEventoPorId`.

## 6.1 Extra opcional: mensagem vira evento (45 s)
- Enviar uma mensagem **sem** `evento_id` (por exemplo a do Desafio 2). Mostrar que um evento novo
  aparece no topo da lista, com o ícone de sino, e que tocar na notificação abre esse evento.
- Explicar: com `evento_id` o app abre o evento existente (Desafio 3); sem ele, a mensagem cria um evento novo.
- Observação: este extra não vale pontos, então fica por último e curto.

## 7. Observação técnica e encerramento (45 s)
- "Com o app aberto, o Android não exibe a notificação automaticamente, então exibi um aviso
  dentro do app com botão para ver o evento."
- "Dados definidos no código, sem login, sem backend; envio manual pelo Firebase Console, plano Spark."
- Mostrar o link do repositório Git e agradecer.

## Checklist antes de gravar
- [ ] Aparelho Android com permissão de notificações concedida
- [ ] Token FCM copiado / mensagem pronta no Console para cada desafio
- [ ] URL da imagem testada no navegador do celular
- [ ] Gravação de tela com som do aparelho ou narração
- [ ] Repositório Git atualizado (com estas alterações) e público/acessível ao professor
