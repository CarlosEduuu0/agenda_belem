class Evento {
  final int id;
  final String titulo;
  final String resumo;
  final String descricao;
  final String local;
  final String data;

  /// Imagem opcional (URL https), vinda da notificação.
  final String? imagemUrl;

  /// Identificador da mensagem FCM que originou o evento (evita duplicados).
  final String? messageId;

  /// true = evento criado a partir de uma notificação recebida.
  final bool recebido;

  const Evento({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.descricao,
    required this.local,
    required this.data,
    this.imagemUrl,
    this.messageId,
    this.recebido = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'resumo': resumo,
        'descricao': descricao,
        'local': local,
        'data': data,
        'imagemUrl': imagemUrl,
        'messageId': messageId,
        'recebido': recebido,
      };

  factory Evento.fromJson(Map<String, dynamic> j) => Evento(
        id: j['id'] as int,
        titulo: j['titulo'] as String,
        resumo: j['resumo'] as String,
        descricao: j['descricao'] as String,
        local: j['local'] as String,
        data: j['data'] as String,
        imagemUrl: j['imagemUrl'] as String?,
        messageId: j['messageId'] as String?,
        recebido: (j['recebido'] as bool?) ?? true,
      );
}
