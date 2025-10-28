import 'package:cwt_ecommerce_admin_panel/localization/Languages/brazilian.dart';
import 'package:get/get.dart';

import 'Languages/english.dart';
import 'Languages/french.dart';
import 'Languages/german.dart';
import 'Languages/portuguese.dart';
import 'Languages/russian.dart';
import 'Languages/spanish.dart';
import 'Languages/vietnamese.dart';

class Languages extends Translations{

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US' : English.language,
    'fr_CA': French.language,
    'de_DE': German.language,
    'pt_PT': Portuguese.language,
    'pt_BR': Brazilian.language,
    'vi_VN': Vietnamese.language,
    'es_ES': Spanish.language,
    'ru_RU': Russian.language,
  };

}