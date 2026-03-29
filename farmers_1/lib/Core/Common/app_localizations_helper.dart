import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_1/Core/Provider/language_provider.dart';
import 'package:farmers_1/l10n/app_localizations.dart';
import 'package:farmers_1/l10n/app_localizations_st.dart';
import 'package:farmers_1/l10n/app_localizations_af.dart';
import 'package:farmers_1/l10n/app_localizations_en.dart';

class AppLocalizationsHelper {
  static AppLocalizations of(BuildContext context) {
    final language = ProviderScope.containerOf(context).read(languageProvider);

    switch (language) {
      case AppLanguage.sesotho:
        return AppLocalizationsSt();
      case AppLanguage.afrikaans:
        return AppLocalizationsAf();
      case AppLanguage.english:
        return AppLocalizationsEn();
    }
  }
}
