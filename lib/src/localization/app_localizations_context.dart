import 'package:flutter/widgets.dart';
// * If this import doesn't work, run this:
// * View > Command Palette > Dart: Restart Analysis Server.
// * More info here: https://stackoverflow.com/questions/64574620/target-of-uri-doesnt-exist-packageflutter-gen-gen-l10n-gallery-localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
