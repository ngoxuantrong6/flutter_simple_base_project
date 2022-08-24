import 'package:flutter_simple_base_project/modules/auth/screens/sign_in_screen.dart';
import 'package:flutter_simple_base_project/modules/auth/viewmodel/sign_in_viewmodel.dart';
import 'package:provider/provider.dart';

import 'page_config.dart';

enum AppPages {
  Initial,
  Next_SignInScreen,
}

String _getPageArgumentErrorString(List<String> args) => args.join(', ');

Never _areRequired(List<String> properties) {
  throw ArgumentError.notNull(_getPageArgumentErrorString(properties));
}

void _checkMissingRequiredArgumentsAndAssureError(
  Map<String, dynamic>? arguments,
  List<String> argNames,
) {
  try {
    if (arguments == null) _areRequired(argNames);

    final List<String> missingArgNames =
        argNames.where((e) => arguments.containsKey(e) == false).toList();

    if (missingArgNames.isNotEmpty) _areRequired(missingArgNames);
  } catch (e) {
    // ignore: avoid_print
    print(e);

    rethrow;
  }
}

final RegExp _keyPattern = RegExp('(?<=[a-z])[A-Z]');

extension AppPagesExtension on AppPages {
  String get key => this
      .toString()
      .split('.')
      .last
      .replaceAll('_', '.')
      .replaceAllMapped(
        _keyPattern,
        (Match m) => "_${m.group(0) ?? ''}",
      )
      .toLowerCase();

  String get path => "/${this.key.replaceAll('.', '/')}";

  String get name => path;

  static PageConfig getPageConfig(
    AppPages page,
    Map<String, dynamic>? arguments,
  ) {
    switch (page) {
      // case AppPages.Initial:

      case AppPages.Next_SignInScreen:
        return PageConfig()
          ..pageBuilder = () => ChangeNotifierProvider(
              create: (_) => LoginModel(),
              builder: (context, child) {
                return const SignInScreen();
              });

      default:
        throw StateError(
          "Missing page: ${page.toString()} in AppPagesExtension.getPageConfig()",
        );
    }
  }

  static PageConfig getPageConfigForUnknownRouteName(String? name) =>
      getPageConfig(
        name == AppPages.Initial.name || name?.isEmpty == true
            ? AppPages.Initial
            : AppPages.values.firstWhere(
                (e) => e.name.contains(name!),
                orElse: () => AppPages.Initial,
              ),
        {},
      );
}
