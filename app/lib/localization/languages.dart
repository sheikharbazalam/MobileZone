import 'package:get/get.dart';

import 'Languages/english.dart';
import 'Languages/french.dart';
import 'Languages/russian.dart';
import 'Languages/german.dart';
import 'Languages/portuguese.dart';
import 'Languages/brazilian.dart';
import 'Languages/spanish.dart';
import 'Languages/vietnamese.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': English.language,
    'fr': French.language,
    'ru': Russian.language,
    'de': German.language,
    'pt': Portuguese.language,
    'pt_BR': PortugueseBR.language,
    'vi': Vietnamese.language,
    'es': Spanish.language,
  };
}
