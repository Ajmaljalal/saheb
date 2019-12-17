import 'package:intl/intl.dart' as international;

bool isRTL(String text) {
  return international.Bidi.detectRtlDirectionality(text);
}
