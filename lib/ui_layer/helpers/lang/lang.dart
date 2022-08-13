import 'dart:ui';

import 'package:nations/nations.dart';

/// Nations Package config
class AppLangConfig extends NationsConfig {
  @override
  Locale get fallbackLocale => const Locale('ar');
  @override
  List<Locale> get supportedLocales => const <Locale>[
        Locale('ar'),
        Locale('en'),
      ];
}
