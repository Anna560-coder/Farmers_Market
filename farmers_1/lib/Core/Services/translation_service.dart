import 'package:translator/translator.dart';
import 'package:farmers_1/Core/Provider/language_provider.dart';

class TranslationService {
  static final GoogleTranslator _translator = GoogleTranslator();

  static const Map<AppLanguage, String> _languageCodes = {
    AppLanguage.english: 'en',
    AppLanguage.sesotho: 'st',
    AppLanguage.afrikaans: 'af',
  };

  static Future<String> detectLanguage(String text) async {
    try {
      final lowerText = text.toLowerCase().trim();

      if (lowerText.length < 3) {
        return 'en';
      }

      final sesothoScore = _calculateLanguageScore(
        lowerText,
        _getSesothoWords(),
      );
      final afrikaansScore = _calculateLanguageScore(
        lowerText,
        _getAfrikaansWords(),
      );
      final englishScore = _calculateLanguageScore(
        lowerText,
        _getEnglishWords(),
      );

      if (sesothoScore > afrikaansScore && sesothoScore > englishScore) {
        return 'st';
      } else if (afrikaansScore > englishScore) {
        return 'af';
      } else {
        return 'en';
      }
    } catch (e) {
      return 'en';
    }
  }

  static double _calculateLanguageScore(String text, List<String> words) {
    int matches = 0;
    for (String word in words) {
      if (text.contains(word)) {
        matches++;
      }
    }
    return matches / words.length;
  }

  static Future<String> translateText({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    try {
      if (fromLanguage == toLanguage) {
        return text;
      }

      if (toLanguage == 'st') {
        try {
          final translation = await _translator.translate(
            text,
            from: fromLanguage,
            to: 'st',
          );
          return translation.text;
        } catch (e) {
          return _getBasicSesothoTranslation(text);
        }
      }

      if (toLanguage == 'af') {
        try {
          final translation = await _translator.translate(
            text,
            from: fromLanguage,
            to: 'af',
          );
          return translation.text;
        } catch (e) {
          return _getBasicAfrikaansTranslation(text);
        }
      }

      final translation = await _translator.translate(
        text,
        from: fromLanguage,
        to: toLanguage,
      );

      return translation.text;
    } catch (e) {
      return text;
    }
  }

  static Future<String> translateToAppLanguage({
    required String text,
    required AppLanguage targetLanguage,
  }) async {
    try {
      final targetLangCode = _languageCodes[targetLanguage] ?? 'en';

      if (targetLangCode == 'en') {
        return text;
      }

      final sourceLangCode = await detectLanguage(text);

      return await translateText(
        text: text,
        fromLanguage: sourceLangCode,
        toLanguage: targetLangCode,
      );
    } catch (e) {
      return text;
    }
  }

  static Future<String> translateToEnglish({
    required String text,
    required AppLanguage sourceLanguage,
  }) async {
    try {
      final sourceLangCode = _languageCodes[sourceLanguage] ?? 'en';

      if (sourceLangCode == 'en') {
        return text;
      }

      if (sourceLangCode == 'st' || sourceLangCode == 'af') {
        try {
          final translation = await _translator.translate(
            text,
            from: sourceLangCode,
            to: 'en',
          );
          return translation.text;
        } catch (e) {
          if (sourceLangCode == 'st') {
            return _getBasicEnglishFromSesotho(text);
          } else if (sourceLangCode == 'af') {
            return _getBasicEnglishFromAfrikaans(text);
          }
          return text;
        }
      }

      return await translateText(
        text: text,
        fromLanguage: sourceLangCode,
        toLanguage: 'en',
      );
    } catch (e) {
      return text;
    }
  }

  static String _getBasicSesothoTranslation(String text) {
    final translations = {
      'crops': 'dijo tsa temo',
      'farming': 'temiso',
      'soil': 'mohlo',
      'water': 'metsi',
      'seeds': 'peo',
      'fertilizer': 'mofuthu',
      'pests': 'ditshila',
      'weather': 'boemo ba leholimo',
      'rain': 'pula',
      'sun': 'letsatsi',
      'plant': 'jalla',
      'harvest': 'kolla',
      'field': 'masimo',
      'cattle': 'likhomo',
      'sheep': 'dinku',
      'goats': 'dipudi',
      'chicken': 'khoho',

      'help': 'thuso',
      'question': 'potso',
      'answer': 'karabo',
      'good': 'hantle',
      'bad': 'mpe',
      'how': 'joang',
      'what': 'eng',
      'when': 'neng',
      'where': 'hae',
      'why': 'hobaneng',
      'yes': 'ee',
      'no': 'che',
      'thank you': 'kea leboha',
      'please': 'ka kopo',

      'maize': 'poone',
      'wheat': 'korong',
      'tomatoes': 'tamati',
      'vegetables': 'meroho',
      'fruits': 'ditholo',
      'trees': 'difate',
      'garden': 'serapa',
      'farm': 'mohaho',
      'farmer': 'molemi',
      'agriculture': 'temiso',
      'irrigation': 'ho neha metsi',
      'drought': 'tlala',
      'flood': 'metsi a makatsang',
      'season': 'nako',
      'spring': 'selemo',
      'summer': 'lehlabula',
      'autumn': 'hoetla',
      'winter': 'maruru',

      'best': 'e ntle ka ho fetisisa',
      'worst': 'e mpe ka ho fetisisa',
      'recommended': 'e khothalelwang',
      'prevent': 'thibela',
      'improve': 'ntlafatsa',
      'store': 'boloka',
      'care': 'hlokomela',
      'grow': 'hola',
      'time': 'nako',
      'often': 'hangata',
      'natural': 'tlhaho',
      'organic': 'tlhaho',

      'i am': 'ke',
      'you are': 'u',
      'we are': 're',
      'they are': 'ba',
      'it is': 'ke',
      'this is': 'ena ke',
      'that is': 'eona ke',
      'there is': 'ho na le',
      'there are': 'ho na le',
      'i have': 'ke na le',
      'you have': 'u na le',
      'we have': 're na le',
      'they have': 'ba na le',
      'i can': 'ke ka',
      'you can': 'u ka',
      'we can': 're ka',
      'they can': 'ba ka',
      'i will': 'ke tla',
      'you will': 'u tla',
      'we will': 're tla',
      'they will': 'ba tla',
      'i should': 'ke tlameha',
      'you should': 'u tlameha',
      'we should': 're tlameha',
      'they should': 'ba tlameha',

      'plant crops': 'jalla dijo tsa temo',
      'water plants': 'neha metsi difate',
      'harvest crops': 'kolla dijo tsa temo',
      'take care of': 'hlokomela',
      'protect from': 'tshireletsa ho tsoa ho',
      'grow well': 'hola hantle',
      'grow better': 'hola hantle ho feta',
      'soil quality': 'boleng ba mohlo',
      'weather conditions': 'maemo a boemo ba leholimo',
      'farming season': 'nako ya temiso',
      'planting season': 'nako ya ho jalla',
      'harvest season': 'nako ya ho kolla',
    };

    String result = text.toLowerCase();

    final phrases = {
      'how do i': 'ke tlameha joang ho',
      'how can i': 'ke ka joang ho',
      'what should i': 'eng ke tlameha ho',
      'when should i': 'neng ke tlameha ho',
      'where should i': 'hae ke tlameha ho',
      'why should i': 'hobaneng ke tlameha ho',
      'i need to': 'ke hloka ho',
      'you need to': 'u hloka ho',
      'we need to': 're hloka ho',
      'they need to': 'ba hloka ho',
      'it is important to': 'ho bohlokoa ho',
      'it is good to': 'ho hantle ho',
      'it is bad to': 'ho mpe ho',
      'it is better to': 'ho hantle ho feta ho',
      'the best way to': 'mokhoa o motle ka ho fetisisa oa ho',
      'the worst way to': 'mokhoa o mpe ka ho fetisisa oa ho',
      'i recommend': 'ke khothalela',
      'i suggest': 'ke etsa boikano',
      'i advise': 'ke keletso',
      'you should know': 'u tlameha ho tseba',
      'it is recommended': 'ho khothalelwa',
      'it is suggested': 'ho etsoa boikano',
      'it is advised': 'ho keletsoa',
    };

    phrases.forEach((english, sesotho) {
      if (result.contains(english)) {
        result = result.replaceAll(english, sesotho);
      }
    });

    translations.forEach((english, sesotho) {
      result = result.replaceAll(english, sesotho);
    });

    return result;
  }

  static String _getBasicAfrikaansTranslation(String text) {
    final translations = {
      'crops': 'gewasse',
      'farming': 'boerdery',
      'soil': 'grond',
      'water': 'water',
      'seeds': 'saad',
      'fertilizer': 'kunsmis',
      'pests': 'plae',
      'weather': 'weer',
      'rain': 'reën',
      'sun': 'son',
      'plant': 'plant',
      'harvest': 'oes',
      'field': 'land',
      'cattle': 'beeste',
      'sheep': 'skape',
      'goats': 'bokke',
      'chicken': 'hoender',

      'help': 'hulp',
      'question': 'vraag',
      'answer': 'antwoord',
      'good': 'goed',
      'bad': 'sleg',
      'how': 'hoe',
      'what': 'wat',
      'when': 'wanneer',
      'where': 'waar',
      'why': 'waarom',
      'yes': 'ja',
      'no': 'nee',
      'thank you': 'dankie',
      'please': 'asseblief',

      'maize': 'mielies',
      'wheat': 'koring',
      'tomatoes': 'tamaties',
      'vegetables': 'groente',
      'fruits': 'vrugte',
      'trees': 'bome',
      'garden': 'tuin',
      'farm': 'plaas',
      'farmer': 'boer',
      'agriculture': 'landbou',
      'irrigation': 'besproeiing',
      'drought': 'droogte',
      'flood': 'vloed',
      'season': 'seisoen',
      'spring': 'lente',
      'summer': 'somer',
      'autumn': 'herfs',
      'winter': 'winter',

      'best': 'beste',
      'worst': 'slegste',
      'recommended': 'aanbeveel',
      'prevent': 'voorkom',
      'improve': 'verbeter',
      'store': 'stoor',
      'care': 'sorg',
      'grow': 'groei',
      'time': 'tyd',
      'often': 'dikwels',
      'natural': 'natuurlik',
      'organic': 'organies',
    };

    String result = text.toLowerCase();
    translations.forEach((english, afrikaans) {
      result = result.replaceAll(english, afrikaans);
    });

    return result;
  }

  static String _getBasicEnglishFromSesotho(String text) {
    final translations = {
      'dijo tsa temo': 'crops',
      'temiso': 'farming',
      'mohlo': 'soil',
      'metsi': 'water',
      'peo': 'seeds',
      'mofuthu': 'fertilizer',
      'ditshila': 'pests',
      'boemo ba leholimo': 'weather',
      'pula': 'rain',
      'letsatsi': 'sun',
      'jalla': 'plant',
      'kolla': 'harvest',
      'masimo': 'field',
      'likhomo': 'cattle',
      'dinku': 'sheep',
      'dipudi': 'goats',
      'khoho': 'chicken',
      'thuso': 'help',
      'potso': 'question',
      'karabo': 'answer',
      'hantle': 'good',
      'mpe': 'bad',
      'joang': 'how',
      'eng': 'what',
      'neng': 'when',
      'hae': 'where',
      'hobaneng': 'why',
      'ee': 'yes',
      'che': 'no',
      'kea leboha': 'thank you',
      'ka kopo': 'please',
      'poone': 'maize',
      'korong': 'wheat',
      'tamati': 'tomatoes',
      'meroho': 'vegetables',
      'ditholo': 'fruits',
      'difate': 'trees',
      'serapa': 'garden',
      'mohaho': 'farm',
      'molemi': 'farmer',
      'maruru': 'winter',
      'selemo': 'spring',
      'lehlabula': 'summer',
      'hoetla': 'autumn',
    };

    String result = text.toLowerCase();
    translations.forEach((sesotho, english) {
      result = result.replaceAll(sesotho, english);
    });

    return result;
  }

  static String _getBasicEnglishFromAfrikaans(String text) {
    final translations = {
      'gewasse': 'crops',
      'boerdery': 'farming',
      'grond': 'soil',
      'water': 'water',
      'saad': 'seeds',
      'kunsmis': 'fertilizer',
      'plae': 'pests',
      'weer': 'weather',
      'reën': 'rain',
      'son': 'sun',
      'plant': 'plant',
      'oes': 'harvest',
      'land': 'field',
      'beeste': 'cattle',
      'skape': 'sheep',
      'bokke': 'goats',
      'hoender': 'chicken',
      'hulp': 'help',
      'vraag': 'question',
      'antwoord': 'answer',
      'goed': 'good',
      'sleg': 'bad',
      'hoe': 'how',
      'wat': 'what',
      'wanneer': 'when',
      'waar': 'where',
      'waarom': 'why',
      'ja': 'yes',
      'nee': 'no',
      'dankie': 'thank you',
      'asseblief': 'please',
      'mielies': 'maize',
      'koring': 'wheat',
      'tamaties': 'tomatoes',
      'groente': 'vegetables',
      'vrugte': 'fruits',
      'bome': 'trees',
      'tuin': 'garden',
      'plaas': 'farm',
      'boer': 'farmer',
      'landbou': 'agriculture',
      'besproeiing': 'irrigation',
      'droogte': 'drought',
      'vloed': 'flood',
      'seisoen': 'season',
      'lente': 'spring',
      'somer': 'summer',
      'herfs': 'autumn',
      'winter': 'winter',
    };

    String result = text.toLowerCase();
    translations.forEach((afrikaans, english) {
      result = result.replaceAll(afrikaans, english);
    });

    return result;
  }

  static List<String> _getSesothoWords() {
    return [
      'ke',
      'le',
      'ho',
      'ka',
      'ha',
      'se',
      'sa',
      'ba',
      'bo',
      'mo',
      'na',
      'la',
      'tsa',
      'tsa',
      'tsa',
      'tsa',
      'tsa',
      'tsa',
      'tsa',
      'tsa',
      'mohlomong',
      'hobane',
      'haeba',
      'ka hore',
      'ka lebaka',
      'joang',
      'eng',
      'neng',
      'hae',
      'hobaneng',
      'hantle',
      'mpe',
      'thuso',
      'potso',
      'karabo',
      'dijo',
      'temiso',
      'mohlo',
      'metsi',
      'peo',
      'mofuthu',
      'ditshila',
      'pula',
      'letsatsi',
      'jalla',
      'kolla',
      'masimo',
      'likhomo',
      'dinku',
      'dipudi',
      'khoho',

      'difate',
      'meroho',
      'poone',
      'mabele',
      'lefatshe',
      'mobu',
      'metsi',
      'pula',
      'maruru',
      'mohla',
      'selemo',
      'ho jalla',
      'ho kolla',
      'ho hlokomela',
      'ho neha',
      'ho boloka',
    ];
  }

  static List<String> _getAfrikaansWords() {
    return [
      'die',
      'van',
      'en',
      'is',
      'in',
      'op',
      'vir',
      'met',
      'aan',
      'by',
      'wat',
      'nie',
      'sal',
      'kan',
      'moet',
      'wil',
      'het',
      'was',
      'word',
      'omdat',
      'wanneer',
      'indien',
      'alhoewel',
      'tensy',
      'as',
      'dan',
      'hoe',
      'waar',
      'waarom',
      'goed',
      'sleg',
      'hulp',
      'vraag',
      'antwoord',

      'gewasse',
      'boerdery',
      'grond',
      'water',
      'saad',
      'kunsmis',
      'plae',
      'weer',
      'reën',
      'son',
      'plant',
      'oes',
      'land',
      'beeste',
      'skape',
      'bokke',
      'hoender',
      'groente',
      'vrugte',
      'blomme',
      'bome',
    ];
  }

  static List<String> _getEnglishWords() {
    return [
      'the',
      'and',
      'is',
      'in',
      'on',
      'for',
      'with',
      'at',
      'by',
      'to',
      'what',
      'not',
      'will',
      'can',
      'must',
      'want',
      'have',
      'was',
      'be',
      'because',
      'when',
      'if',
      'although',
      'unless',
      'how',
      'where',
      'why',
      'good',
      'bad',
      'help',
      'question',
      'answer',
      'crops',
      'farming',

      'soil',
      'water',
      'seeds',
      'fertilizer',
      'pests',
      'weather',
      'rain',
      'sun',
      'plant',
      'harvest',
      'field',
      'cattle',
      'sheep',
      'goats',
      'chicken',
      'vegetables',
      'fruits',
      'flowers',
      'trees',
      'garden',
    ];
  }
}
