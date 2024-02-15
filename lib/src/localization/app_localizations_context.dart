import 'package:flutter/widgets.dart';
// * If this import doesn't work, run this:
// * View > Command Palette > Dart: Restart Analysis Server.
// * More info here: https://stackoverflow.com/questions/64574620/target-of-uri-doesnt-exist-packageflutter-gen-gen-l10n-gallery-localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Helper extension that allows to type this:
/// Text(context.loc.someString)
/// rather than this:
/// Text(AppLocalizations.of(context).someString)
///
/// More info here:
/// https://codewithandrea.com/articles/flutter-localization-build-context-extension/
extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
