/// Starter templates. All prompts are original and use no copyrighted
/// characters, logos or brands. Users can edit every prompt.
class VideoTemplate {
  final String id;
  final String categoryKey; // matches a "cat.*" translation key suffix
  final String titleEn;
  final String titleHa;
  final String descEn;
  final String descHa;
  final String prompt;
  final String aspect;
  final String safetyKey; // matches a "safety.*" translation key

  const VideoTemplate({
    required this.id,
    required this.categoryKey,
    required this.titleEn,
    required this.titleHa,
    required this.descEn,
    required this.descHa,
    required this.prompt,
    required this.aspect,
    this.safetyKey = 'safety.default',
  });

  String title(String lang) => lang == 'ha' ? titleHa : titleEn;
  String desc(String lang) => lang == 'ha' ? descHa : descEn;
}

const List<VideoTemplate> kTemplates = <VideoTemplate>[
  VideoTemplate(
    id: 'action',
    categoryKey: 'action',
    titleEn: 'Chase Scene Opener',
    titleHa: 'Farkon Fim na Fafatawa',
    descEn: 'A fast opening shot for an action short.',
    descHa: 'Gajeren fage mai sauri na fim ɗin fafatawa.',
    prompt:
        'A motorbike races through a busy city street at dusk, camera tracking alongside, dust and sparks, dramatic lighting, cinematic.',
    aspect: '16:9',
  ),
  VideoTemplate(
    id: 'trailer',
    categoryKey: 'trailer',
    titleEn: 'Epic Trailer Teaser',
    titleHa: 'Gajeren Tallan Fim',
    descEn: 'A moody teaser with slow, powerful shots.',
    descHa: 'Gajeren talla mai ɗaukar hankali da jinkirin motsi.',
    prompt:
        'Wide shot of a lone traveler crossing a vast desert at sunrise, wind blowing sand, slow camera push-in, epic cinematic mood.',
    aspect: '16:9',
  ),
  VideoTemplate(
    id: 'comedy',
    categoryKey: 'comedy',
    titleEn: 'Market Day Comedy',
    titleHa: 'Barkwancin Ranar Kasuwa',
    descEn: 'A light comic scene set in a lively market.',
    descHa: 'Wani yanayi na raha a kasuwa mai cunkoso.',
    prompt:
        'A cheerful trader and a customer playfully bargain over a basket of tomatoes in a colorful open-air market, warm daylight, lively background.',
    aspect: '9:16',
  ),
  VideoTemplate(
    id: 'storytelling',
    categoryKey: 'story',
    titleEn: 'Village Tale Narration',
    titleHa: 'Labarin Ƙauye',
    descEn: 'Visuals to accompany a spoken folk tale.',
    descHa: 'Hotuna masu tafiya tare da bayar da labari.',
    prompt:
        'Children sit around a fire under a starry night sky while an elder tells a story, soft warm light, gentle camera drift, calm atmosphere.',
    aspect: '16:9',
  ),
  VideoTemplate(
    id: 'business',
    categoryKey: 'business',
    titleEn: 'Shop Promo Ad',
    titleHa: 'Tallan Shago',
    descEn: 'A short ad for a small business.',
    descHa: 'Gajeren talla ga ƙaramin kasuwanci.',
    prompt:
        'A neat, welcoming fabric shop with colorful cloth rolls on display, a smiling shopkeeper arranging items, bright clean lighting, smooth camera pan.',
    aspect: '9:16',
    safetyKey: 'safety.claims',
  ),
  VideoTemplate(
    id: 'product',
    categoryKey: 'product',
    titleEn: 'Product Showcase',
    titleHa: 'Nuna Kayan Sayarwa',
    descEn: 'A clean rotating view of a product.',
    descHa: 'Kallon kayan sayarwa a hankali daga kowane gefe.',
    prompt:
        'A handmade leather bag on a simple pedestal, slowly rotating, soft studio lighting, neutral background, sharp detail.',
    aspect: '1:1',
    safetyKey: 'safety.claims',
  ),
  VideoTemplate(
    id: 'islamic',
    categoryKey: 'islamic',
    titleEn: 'Educational Reminder',
    titleHa: 'Darasin Ilimin Addini',
    descEn: 'Calm visuals for an educational talk.',
    descHa: 'Hotuna masu sanyi don darasi na ilimi.',
    prompt:
        'A peaceful mosque courtyard at dawn with soft golden light, quiet reflections on the floor, slow gentle camera movement, no people in frame.',
    aspect: '16:9',
    safetyKey: 'safety.islamic',
  ),
  VideoTemplate(
    id: 'kids',
    categoryKey: 'kids',
    titleEn: 'Alphabet Adventure',
    titleHa: 'Tafiyar Haruffa',
    descEn: 'Playful animated letters for young learners.',
    descHa: 'Haruffa masu motsi da annashuwa ga yara masu koyo.',
    prompt:
        'Friendly cartoon animals walk past large colorful letters in a sunny meadow, simple shapes, bright colors, cheerful and gentle style.',
    aspect: '16:9',
    safetyKey: 'safety.kids',
  ),
  VideoTemplate(
    id: 'documentary',
    categoryKey: 'doc',
    titleEn: 'City Life Documentary',
    titleHa: 'Rayuwar Birni',
    descEn: 'Observational shots of everyday city life.',
    descHa: 'Hotunan rayuwar yau da kullum a birni.',
    prompt:
        'Aerial view of a growing West African city at golden hour, traffic and rooftops, then street-level shots of people going about their day, documentary style.',
    aspect: '16:9',
  ),
  VideoTemplate(
    id: 'social',
    categoryKey: 'social',
    titleEn: 'Vertical Social Clip',
    titleHa: 'Gajeren Bidiyon Sada Zumunta',
    descEn: 'An eye-catching vertical clip.',
    descHa: 'Gajeren bidiyo a tsaye mai jan hankali.',
    prompt:
        'Close-up of fresh street food being cooked on a hot grill, steam rising, vibrant colors, quick dynamic camera moves, vertical framing.',
    aspect: '9:16',
  ),
  VideoTemplate(
    id: 'fashion',
    categoryKey: 'fashion',
    titleEn: 'Fabric and Style Lookbook',
    titleHa: 'Nuna Tufafi da Ado',
    descEn: 'A stylish look at fabrics and outfits.',
    descHa: 'Kallon kayan sawa da yadi masu kyau.',
    prompt:
        'Flowing patterned fabric in the wind against a plain wall, close details of stitching and texture, soft natural light, elegant slow motion.',
    aspect: '9:16',
  ),
  VideoTemplate(
    id: 'music',
    categoryKey: 'music',
    titleEn: 'Beat Visualizer',
    titleHa: 'Zanen Kiɗa Mai Motsi',
    descEn: 'Abstract visuals that move with a beat.',
    descHa: 'Zane-zane marasa tsari masu bin sautin kiɗa.',
    prompt:
        'Abstract glowing shapes pulse and ripple in violet and cyan on a dark background, smooth rhythmic motion, seamless loop.',
    aspect: '16:9',
  ),
  VideoTemplate(
    id: 'motivation',
    categoryKey: 'motivation',
    titleEn: 'Morning Motivation',
    titleHa: 'Ƙarfafa Gwiwa ta Safiya',
    descEn: 'An uplifting sunrise sequence.',
    descHa: 'Jerin hotunan fitowar rana masu ƙarfafa zuciya.',
    prompt:
        'A runner jogs along a quiet road as the sun rises over green fields, long shadows, hopeful atmosphere, smooth tracking shot.',
    aspect: '9:16',
  ),
  VideoTemplate(
    id: 'events',
    categoryKey: 'events',
    titleEn: 'Event Announcement',
    titleHa: 'Sanarwar Taro',
    descEn: 'A bright intro for an upcoming event.',
    descHa: 'Gabatarwa mai haske ga taro mai zuwa.',
    prompt:
        'Colorful lights sweep over an empty stage as banners unfurl, anticipation building, festive atmosphere, dynamic camera rise.',
    aspect: '16:9',
  ),
];
