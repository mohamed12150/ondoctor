import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'title': 'Welcome',
      'switch_lang': 'Switch to Arabic',
      'dark_mode': 'Toggle Dark Mode',
    },
    'ar': {
      'title': 'مرحبا',
      'switch_lang': 'التبديل إلى الإنجليزية',
      'dark_mode': 'تبديل الوضع الداكن',
    },
  };
}
