/// All interface text lives here, in one place, for English ("en") and Hausa ("ha").
///
/// NOTE: The Hausa text is a first draft and should be reviewed by a native
/// Hausa speaker before public release.
///
/// If a key is missing in the chosen language, English is used. If it is
/// missing in English too, the key itself is shown (so gaps are visible,
/// never blank).
class Strings {
  static const List<String> supported = ['en', 'ha'];

  static String t(String lang, String key) {
    final String? inLang = _data[lang]?[key];
    if (inLang != null) return inLang;
    final String? inEn = _data['en']?[key];
    if (inEn != null) return inEn;
    return '[$key]';
  }

  static const Map<String, Map<String, String>> _data = {
    'en': _en,
    'ha': _ha,
  };

  static const Map<String, String> _en = {
    'app.tagline': 'Imagine It. Create It.',
    'app.altTagline': 'Your Imagination, Your Studio.',
    'nav.home': 'Home',
    'nav.create': 'Create',
    'nav.projects': 'Projects',
    'nav.templates': 'Templates',
    'nav.profile': 'Profile',
    'common.planned': 'Planned',
    'common.available': 'Available',
    'common.close': 'Close',
    'common.delete': 'Delete',
    'common.use': 'Use',

    'home.cta': 'Create Your First Video',
    'home.explore': 'Explore Templates',
    'home.intro':
        'Turn an idea into a video. Write a prompt, choose a model and create, all in one place.',
    'home.status.title': 'Platform status',
    'home.status.noProvider':
        'No AI provider is connected yet. Generation is disabled until one is configured.',
    'home.status.connected': 'AI providers connected: {n}',
    'home.credits': 'Credits: unavailable (billing is not active).',
    'home.features': 'What NIG_VID is built for',

    'tool.t2v': 'Text to Video',
    'tool.t2v.desc': 'Describe a scene and generate a video from it.',
    'tool.i2v': 'Image to Video',
    'tool.i2v.desc': 'Animate an image you have the rights to use.',
    'tool.t2i': 'AI Images',
    'tool.t2i.desc': 'Generate images from a text description.',
    'tool.editor': 'Video Editor',
    'tool.editor.desc': 'Trim, arrange and export clips on a timeline.',
    'tool.story': 'Story to Movie',
    'tool.story.desc': 'Turn a story into scenes and generate each one.',
    'tool.voice': 'Voice and Subtitles',
    'tool.voice.desc': 'Add narration and Hausa or English subtitles.',

    'create.title': 'Create',
    'create.pick': 'Choose a tool',
    'create.planned.body':
        'This tool is planned for a later phase and is not available yet.',

    'ws.prompt': 'Prompt',
    'ws.hint': 'Describe what you want to create (English or Hausa)...',
    'ws.chars': '{n} characters',
    'ws.clear': 'Clear',
    'ws.save': 'Save prompt',
    'ws.saved': 'Prompt saved on this device.',
    'ws.saveFailed': 'Could not save the prompt.',
    'ws.emptyPrompt': 'Write a prompt first.',
    'ws.model': 'Model',
    'ws.model.none':
        'No model available. Connect a provider to see models and the settings they support.',
    'ws.cost': 'Estimated cost',
    'ws.cost.unavailable': 'Unavailable',
    'ws.generate': 'Generate',
    'ws.generate.disabled':
        'Generation is disabled because no provider is connected.',
    'ws.safety.title': 'Responsible use',
    'ws.safety.body':
        'Do not create content that impersonates a real person without their permission, or that is used for fraud or to mislead. Only use images and voices you have the right to use.',
    'ws.translate.note':
        'Writing in Hausa? Some models understand Hausa less well than English. You will be able to review and edit your prompt before it is submitted.',

    'projects.title': 'Projects',
    'projects.local': 'Local drafts (saved on this device only)',
    'projects.empty': 'No saved drafts yet. Prompts you save appear here.',
    'projects.cloud':
        'Cloud projects need an account, which is not available yet.',

    'templates.title': 'Templates',
    'templates.search': 'Search templates',
    'templates.none': 'No templates match your search.',
    'templates.use': 'Use template',
    'templates.aspect': 'Aspect ratio',
    'templates.example': 'Example prompt (editable)',
    'templates.safety': 'Safety note',

    'profile.title': 'Profile',
    'profile.language': 'Language',
    'profile.account': 'Account',
    'profile.account.body':
        'Sign-in is not available yet. This build stores data only on your device.',
    'profile.pricing': 'Pricing',
    'profile.pricing.body':
        'Paid plans and payments are not active. Nothing is charged.',
    'profile.providers': 'AI providers',
    'profile.providers.none': 'No providers configured.',
    'profile.about': 'About',
    'profile.about.body':
        'NIG_VID does not own or train AI models. Generation will use third-party or self-hosted models that you configure, and each is labeled as such.',
    'profile.version': 'Version',

    'cat.action': 'Action movies',
    'cat.trailer': 'Cinematic trailers',
    'cat.comedy': 'Hausa comedy',
    'cat.story': 'Hausa storytelling',
    'cat.business': 'Business advertising',
    'cat.product': 'Product demonstrations',
    'cat.islamic': 'Islamic educational content',
    'cat.kids': "Children's education",
    'cat.doc': 'Documentary',
    'cat.social': 'Social media videos',
    'cat.fashion': 'Fashion',
    'cat.music': 'Music visualizers',
    'cat.motivation': 'Motivational videos',
    'cat.events': 'Event promotions',

    'ed.import.video': 'Add videos',
    'ed.import.image': 'Add photos',
    'ed.preview.empty': 'Add a video or photo to begin.',
    'ed.timeline': 'Timeline',
    'ed.timeline.empty':
        'Your timeline is empty. Add videos or photos, then drag to reorder them.',
    'ed.total': '{n} clips, total length {t}',
    'ed.trim': 'Trim (start to end)',
    'ed.duration': 'Photo length',
    'ed.delete': 'Remove clip',
    'ed.play': 'Play all',
    'ed.pause': 'Pause',
    'ed.export': 'Export',
    'ed.export.note':
        'Exporting a finished video is not available yet. It needs a video-rendering engine that has not been added.',
    'ed.session.note':
        'Your timeline is not saved. It is lost when you close the editor.',
    'ed.local.note':
        'Files stay on your device. Nothing is uploaded. Large videos may take a moment to open.',
    'ed.unreadable': 'This file could not be opened:',

    'safety.default':
        'Do not impersonate a real person without their permission.',
    'safety.islamic':
        'Do not depict prophets or sacred figures. Have religious content reviewed by a knowledgeable person before publishing.',
    'safety.kids':
        'Keep content age-appropriate and do not use the likeness of a real child.',
    'safety.claims': 'Do not make false claims about products or services.',
  };

  static const Map<String, String> _ha = {
    'app.tagline': 'Ka Yi Tunani. Ka Ƙirƙira.',
    'app.altTagline': 'Tunaninka, Ɗakin Studio ɗinka.',
    'nav.home': 'Gida',
    'nav.create': 'Ƙirƙira',
    'nav.projects': 'Ayyuka',
    'nav.templates': 'Samfura',
    'nav.profile': 'Bayani',
    'common.planned': 'Ana shiri',
    'common.available': 'Akwai',
    'common.close': 'Rufe',
    'common.delete': 'Goge',
    'common.use': 'Yi amfani',

    'home.cta': 'Ƙirƙiri Bidiyonka na Farko',
    'home.explore': 'Duba Samfura',
    'home.intro':
        'Mayar da tunani zuwa bidiyo. Rubuta umarni, zaɓi samfurin AI, sannan ka ƙirƙira, duka a wuri guda.',
    'home.status.title': 'Matsayin dandamali',
    'home.status.noProvider':
        'Ba a haɗa wani mai samar da AI ba tukuna. An hana ƙirƙira har sai an saita ɗaya.',
    'home.status.connected': 'Masu samar da AI da aka haɗa: {n}',
    'home.credits': 'Credits: babu (ba a kunna biyan kuɗi ba).',
    'home.features': 'Abin da aka gina NIG_VID don shi',

    'tool.t2v': 'Rubutu zuwa Bidiyo',
    'tool.t2v.desc': 'Bayyana wani yanayi, a ƙirƙiri bidiyo daga gare shi.',
    'tool.i2v': 'Hoto zuwa Bidiyo',
    'tool.i2v.desc': 'Sa hoton da kake da damar amfani da shi ya yi motsi.',
    'tool.t2i': 'Hotunan AI',
    'tool.t2i.desc': 'Ƙirƙiri hotuna daga bayanin rubutu.',
    'tool.editor': 'Editan Bidiyo',
    'tool.editor.desc': 'Yanke, tsara, da fitar da bidiyo a kan timeline.',
    'tool.story': 'Labari zuwa Fim',
    'tool.story.desc': 'Mayar da labari zuwa fage-fage, a ƙirƙiri kowanne.',
    'tool.voice': 'Murya da Subtitle',
    'tool.voice.desc': 'Ƙara bayar da labari da subtitle na Hausa ko Turanci.',

    'create.title': 'Ƙirƙira',
    'create.pick': 'Zaɓi kayan aiki',
    'create.planned.body':
        'Ana shirin wannan kayan aikin a mataki na gaba. Bai samu ba tukuna.',

    'ws.prompt': 'Umarni',
    'ws.hint': 'Bayyana abin da kake so ka ƙirƙira (Turanci ko Hausa)...',
    'ws.chars': 'haruffa {n}',
    'ws.clear': 'Share',
    'ws.save': 'Ajiye umarni',
    'ws.saved': "An ajiye umarni a wannan na'ura.",
    'ws.saveFailed': 'Ba a iya ajiye umarnin ba.',
    'ws.emptyPrompt': 'Rubuta umarni tukuna.',
    'ws.model': 'Samfurin AI',
    'ws.model.none':
        'Babu samfurin AI. Haɗa mai samar da AI domin ganin samfura da saitunan da suke tallafawa.',
    'ws.cost': 'Kimar farashi',
    'ws.cost.unavailable': 'Babu',
    'ws.generate': 'Ƙirƙira',
    'ws.generate.disabled':
        'An hana ƙirƙira saboda ba a haɗa mai samar da AI ba.',
    'ws.safety.title': 'Amfani cikin alhaki',
    'ws.safety.body':
        'Kada ka ƙirƙiri abin da ke yin koyi da wani mutum na ainihi ba tare da izininsa ba, ko don damfara ko yaudara. Yi amfani da hotuna da muryoyin da kake da damar amfani da su kawai.',
    'ws.translate.note':
        'Kana rubutu da Hausa? Wasu samfura ba sa fahimtar Hausa kamar Turanci. Za ka iya dubawa da gyara umarninka kafin a aika shi.',

    'projects.title': 'Ayyuka',
    'projects.local': "Daftarin gida (a wannan na'ura kawai)",
    'projects.empty':
        'Babu daftarin da aka ajiye tukuna. Umarnin da ka ajiye zai bayyana a nan.',
    'projects.cloud':
        'Ayyukan cikin gajimare suna buƙatar asusu, wanda bai samu ba tukuna.',

    'templates.title': 'Samfura',
    'templates.search': 'Nemi samfura',
    'templates.none': 'Babu samfurin da ya dace da binciken ka.',
    'templates.use': 'Yi amfani da samfurin',
    'templates.aspect': 'Girman allo',
    'templates.example': 'Misalin umarni (ana iya gyarawa)',
    'templates.safety': 'Bayanin tsaro',

    'profile.title': 'Bayani',
    'profile.language': 'Harshe',
    'profile.account': 'Asusu',
    'profile.account.body':
        "Shiga asusu bai samu ba tukuna. Wannan sigar tana ajiye bayanai a na'urarka kawai.",
    'profile.pricing': 'Farashi',
    'profile.pricing.body':
        'Tsare-tsaren biya ba sa aiki. Ba a karɓar kuɗi.',
    'profile.providers': 'Masu samar da AI',
    'profile.providers.none': 'Ba a saita wani mai samarwa ba.',
    'profile.about': 'Game da mu',
    'profile.about.body':
        'NIG_VID ba ta mallaka ko horar da samfuran AI ba. Ƙirƙira za ta yi amfani da samfuran wasu kamfanoni ko na kanka da ka saita, kuma za a rubuta haka a fili.',
    'profile.version': 'Sigar app',

    'cat.action': 'Fina-finan fafatawa',
    'cat.trailer': 'Tallan fina-finai',
    'cat.comedy': 'Barkwancin Hausa',
    'cat.story': 'Bayar da labarin Hausa',
    'cat.business': 'Tallan kasuwanci',
    'cat.product': 'Nuna kayayyaki',
    'cat.islamic': 'Ilimin addinin Musulunci',
    'cat.kids': 'Ilimin yara',
    'cat.doc': 'Shirin gaskiya',
    'cat.social': 'Bidiyon sada zumunta',
    'cat.fashion': 'Ado da kayan sawa',
    'cat.music': 'Zanen kiɗa mai motsi',
    'cat.motivation': 'Bidiyon ƙarfafa gwiwa',
    'cat.events': 'Tallar taruka',

    'ed.import.video': 'Ƙara bidiyo',
    'ed.import.image': 'Ƙara hoto',
    'ed.preview.empty': 'Ƙara bidiyo ko hoto domin farawa.',
    'ed.timeline': 'Timeline',
    'ed.timeline.empty':
        'Timeline ɗinka babu komai. Ƙara bidiyo ko hotuna, sannan ka ja su domin sake tsara su.',
    'ed.total': 'Clip {n}, jimillar tsawo {t}',
    'ed.trim': 'Yanke (daga farko zuwa ƙarshe)',
    'ed.duration': 'Tsawon hoto',
    'ed.delete': 'Cire clip',
    'ed.play': 'Kunna duka',
    'ed.pause': 'Dakata',
    'ed.export': 'Fitar da bidiyo',
    'ed.export.note':
        'Fitar da bidiyo da aka gama bai samu ba tukuna. Yana buƙatar injin ƙirƙirar bidiyo wanda ba a ƙara ba.',
    'ed.session.note':
        'Ba a ajiye timeline ɗinka. Zai ɓace idan ka rufe editan.',
    'ed.local.note':
        "Fayilolin suna zama a na'urarka. Ba a aika komai ba. Manyan bidiyo na iya ɗaukar ɗan lokaci kafin su buɗe.",
    'ed.unreadable': 'Ba a iya buɗe wannan fayil ɗin ba:',

    'safety.default':
        'Kada a yi koyi da wani mutum na ainihi ba tare da izininsa ba.',
    'safety.islamic':
        'Kada a nuna annabawa ko wasu abubuwa masu tsarki. A nemi mai ilimi ya duba abin kafin a wallafa shi.',
    'safety.kids':
        'A tabbatar abin ya dace da shekarun yara, kuma kada a yi amfani da kamannin ainihin yaro.',
    'safety.claims': 'Kada a yi ƙarya game da kayan ko hidimar da ake tallatawa.',
  };
}Game da mu',
    'profile.about.body':
        'NIG_VID ba ta mallaka ko horar da samfuran AI ba. Ƙirƙira za ta yi amfani da samfuran wasu kamfanoni ko na kanka da ka saita, kuma za a rubuta haka a fili.',
    'profile.version': 'Sigar app',

    'cat.action': 'Fina-finan fafatawa',
    'cat.trailer': 'Tallan fina-finai',
    'cat.comedy': 'Barkwancin Hausa',
    'cat.story': 'Bayar da labarin Hausa',
    'cat.business': 'Tallan kasuwanci',
    'cat.product': 'Nuna kayayyaki',
    'cat.islamic': 'Ilimin addinin Musulunci',
    'cat.kids': 'Ilimin yara',
    'cat.doc': 'Shirin gaskiya',
    'cat.social': 'Bidiyon sada zumunta',
    'cat.fashion': 'Ado da kayan sawa',
    'cat.music': 'Zanen kiɗa mai motsi',
    'cat.motivation': 'Bidiyon ƙarfafa gwiwa',
    'cat.events': 'Tallar taruka',

    'safety.default':
        'Kada a yi koyi da wani mutum na ainihi ba tare da izininsa ba.',
    'safety.islamic':
        'Kada a nuna annabawa ko wasu abubuwa masu tsarki. A nemi mai ilimi ya duba abin kafin a wallafa shi.',
    'safety.kids':
        'A tabbatar abin ya dace da shekarun yara, kuma kada a yi amfani da kamannin ainihin yaro.',
    'safety.claims': 'Kada a yi ƙarya game da kayan ko hidimar da ake tallatawa.',
  };
}
