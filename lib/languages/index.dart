import 'package:provider/provider.dart';
import '../store/store.dart';
import 'pashto.dart';
import 'dari.dart';

Map getLanguages(context) {
  String language = Provider.of<Store>(context).getLanguage;
  Map appLanguage;

  if (language == 'pashto') {
    appLanguage = pashto;
  }

  if (language == 'dari') {
    appLanguage = dari;
  }

  return appLanguage;
}
