import '../models/evento.dart';

// Dados fixos no código (permitido pelo enunciado). Eventos fictícios.
const List<Evento> eventos = [
  Evento(
    id: 1,
    titulo: 'Festival de Carimbó',
    resumo: 'Noite de carimbó com grupos tradicionais.',
    descricao:
        'Apresentações de grupos de carimbó com dança, música ao vivo e '
        'oficina aberta para quem quer aprender os primeiros passos.',
    local: 'Mangal das Garças',
    data: 'Sáb, 14 de novembro • 19h',
  ),
  Evento(
    id: 2,
    titulo: 'Feira de Gastronomia Paraense',
    resumo: 'Tacacá, maniçoba, açaí e doces regionais.',
    descricao:
        'Barracas de comidas típicas, degustação de ingredientes regionais '
        'e bate-papo com cozinheiras e cozinheiros locais.',
    local: 'Estação das Docas',
    data: 'Dom, 15 de novembro • 11h',
  ),
  Evento(
    id: 3,
    titulo: 'Feira de Artesanato',
    resumo: 'Cerâmica, biojoias e arte em miriti.',
    descricao:
        'Artesãos de diferentes bairros expõem e vendem peças de cerâmica, '
        'biojoias, brinquedos de miriti e outras criações.',
    local: 'Praça da República',
    data: 'Sáb, 21 de novembro • 9h',
  ),
];

Evento? buscarEventoPorId(int id) {
  for (final e in eventos) {
    if (e.id == id) return e;
  }
  return null;
}
