import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  return AppLocalizationsEn();
});
