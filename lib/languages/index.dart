import 'package:provider/provider.dart';
import '../providers/languageProvider.dart';
import 'pashto.dart';
import 'dari.dart';

Map getLanguages(context) {
  String language = Provider.of<LanguageProvider>(context).getLanguage;
  Map appLanguage;

  if (language == 'pashto') {
    appLanguage = pashto;
  }

  if (language == 'dari') {
    appLanguage = dari;
  }

  return appLanguage;
}
