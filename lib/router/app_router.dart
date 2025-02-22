// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app_pages.dart';
import 'page_config.dart';

enum Transition {
  fadeIn,
  rightToLeft,
  downToUp,
  rightToLeftWithFade,
}

extension _TransitionExtension on Transition {
  Offset? get beginOffset {
    switch (this) {
      case Transition.rightToLeft:
      case Transition.rightToLeftWithFade:
        return const Offset(1.0, 0.0);
      case Transition.downToUp:
        return const Offset(0.0, 1.0);
      default:
        return null;
    }
  }

  static Widget builder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Transition transition,
    Curve? curve,
    Widget child,
  ) {
    const zeroOffset = Offset.zero;

    if (transition == Transition.rightToLeftWithFade) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: transition.beginOffset,
          end: zeroOffset,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    }

    late CurvedAnimation? curvedAnimation =
        curve == null ? null : CurvedAnimation(parent: animation, curve: curve);

    if (transition == Transition.fadeIn)
      return FadeTransition(
        opacity: curvedAnimation ?? animation,
        child: child,
      );

    final tween = Tween(begin: transition.beginOffset, end: zeroOffset);
    curvedAnimation ??= CurvedAnimation(
      parent: animation,
      curve: _defaultTransitionCurve,
    );

    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}

final String _initialPageName = AppPages.Initial.name;
const Transition _defaultTransition = Transition.rightToLeft;
const Curve _defaultTransitionCurve = Curves.easeOutQuad;
const Duration _defaultTransitionDuration = Duration(milliseconds: 320);

PageRouteBuilder<T> _createRoute<T>({
  required PageBuilder pageBuilder,
  required RouteSettings settings,
  Transition? transition,
  Duration? transitionDuration,
  Curve? curve,
  bool opaque = true,
  bool fullscreenDialog = false,
}) =>
    PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => pageBuilder(),
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          _TransitionExtension.builder(
        context,
        animation,
        secondaryAnimation,
        transition ?? _defaultTransition,
        curve,
        child,
      ),
      transitionDuration: transitionDuration ?? _defaultTransitionDuration,
      opaque: opaque,
      fullscreenDialog: fullscreenDialog,
    );

PageRouteBuilder _createRouteFromName(String? name) {
  final PageConfig pageConfig =
      AppPagesExtension.getPageConfigForUnknownRouteName(name);

  return _createRoute(
    pageBuilder: pageConfig.pageBuilder,
    settings: RouteSettings(name: name),
  );
}

class AppRouter {
  static GlobalKey<NavigatorState>? _navigatorKey;

  static GlobalKey<NavigatorState> createNavigatorKeyIfNotExisted() =>
      _navigatorKey ??= GlobalKey<NavigatorState>();

  static NavigatorState? get currentNavigator => _navigatorKey?.currentState;
  static NavigatorState get navigator {
    try {
      return _navigatorKey!.currentState!;
    } catch (e) {
      throw StateError(
        "${e.toString()}. Maybe you did not create Navigator key",
      );
    }
  }

  /// {@macro flutter.widgets.widgetsApp.onGenerateInitialRoutes}
  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) => [
        _createRouteFromName(initialRoute),
      ];

  /// {@macro flutter.widgets.widgetsApp.onUnknownRoute}
  static Route<dynamic>? onUnknownRoute(RouteSettings settings) =>
      _createRouteFromName(settings.name);

  /// https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments#2-create-a-widget-that-extracts-the-arguments
  static Object? extractArguments(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;

  /// * [duration]
  /// The duration the transition going forwards.
  ///
  /// * [opaque]
  ///
  /// {@macro flutter.widgets.TransitionRoute.opaque}
  ///
  /// * [fullscreenDialog]
  ///
  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  static Future<T?> toPage<T, CP extends ChangeNotifier, P, VP>(
    BuildContext context,
    AppPages page, {
    Map<String, dynamic>? arguments,
    P? valueProvider,
    ValueListenable<VP>? valueListenableProvider,
    CP? changeNotifierProvider,
    List<SingleChildWidget>? providers,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    bool? opaque,
    bool? fullscreenDialog,
  }) =>
      (currentNavigator ?? Navigator.of(context)).toPage(
        page,
        arguments: arguments,
        transition: transition,
        valueProvider: valueProvider,
        valueListenableProvider: valueListenableProvider,
        changeNotifierProvider: changeNotifierProvider,
        providers: providers,
        curve: curve,
        duration: duration,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
      );

  /// * [duration]
  /// The duration the transition going forwards.
  static Future<T?>? replaceAllWithPage<T extends Object?>(
    BuildContext context,
    AppPages page, {
    bool Function(Route<dynamic>)? predicate,
    Map<String, dynamic>? arguments,
    Transition? transition,
    Curve? curve,
    Duration? duration,
  }) =>
      (currentNavigator ?? Navigator.of(context)).replaceAllWithPage(
        page,
        predicate: predicate,
        arguments: arguments,
        transition: transition,
        curve: curve,
        duration: duration,
      );

  static void back<T>(
    BuildContext context, {
    T? result,
  }) =>
      (currentNavigator ?? Navigator.of(context)).back(result: result);

  static void backToPageName(BuildContext context, String name) =>
      (currentNavigator ?? Navigator.of(context)).backToPageName(name);

  static void backToPage(BuildContext context, AppPages page) =>
      backToPageName(context, page.name);
}

/// throw StateError when you pushed the same page to the stack
Never _duplicatedPage(String name) =>
    throw StateError("Duplicated Page: $name");

PageBuilder _resolvePageBuilder<CP extends ChangeNotifier, P, VP>({
  required PageBuilder pageBuilder,
  P? valueProvider,
  ValueListenable<VP>? valueListenableProvider,
  CP? changeNotifierProvider,
  List<SingleChildWidget>? providers,
}) {
  final List<SingleChildWidget> effectiveProviders = [
    if (valueProvider != null) Provider.value(value: valueProvider),
    if (valueListenableProvider != null)
      ValueListenableProvider.value(
        value: valueListenableProvider,
      ),
    if (changeNotifierProvider != null)
      ChangeNotifierProvider.value(
        value: changeNotifierProvider,
      ),
    ...?providers,
  ];

  if (effectiveProviders.isEmpty) return pageBuilder;

  return () => MultiProvider(
        providers: effectiveProviders,
        child: (() => pageBuilder())(),
      );
}

extension NavigatorStateExtension on NavigatorState {
  /// * [duration]
  /// The duration the transition going forwards.
  ///
  /// * [opaque]
  ///
  /// {@macro flutter.widgets.TransitionRoute.opaque}
  ///
  /// * [fullscreenDialog]
  ///
  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  Future<T?> toPage<T extends Object?, CP extends ChangeNotifier, P, VP>(
    AppPages page, {
    Map<String, dynamic>? arguments,
    P? valueProvider,
    ValueListenable<VP>? valueListenableProvider,
    CP? changeNotifierProvider,
    List<SingleChildWidget>? providers,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    bool? opaque,
    bool? fullscreenDialog,
  }) {
    final PageConfig pageConfig =
        AppPagesExtension.getPageConfig(page, arguments);

    if (pageConfig.preventDuplicates &&
        widget.pages.isNotEmpty &&
        widget.pages.last.name == page.name) _duplicatedPage(page.name);

    return push<T>(
      _createRoute(
        pageBuilder: _resolvePageBuilder(
          pageBuilder: pageConfig.pageBuilder,
          valueProvider: valueProvider,
          valueListenableProvider: valueListenableProvider,
          changeNotifierProvider: changeNotifierProvider,
          providers: providers,
        ),
        settings: RouteSettings(name: page.name, arguments: arguments),
        transition: transition ?? pageConfig.transition,
        transitionDuration: duration ?? pageConfig.transitionDuration,
        curve: curve ?? pageConfig.curve,
        opaque: opaque ?? pageConfig.opaque,
        fullscreenDialog: fullscreenDialog ?? pageConfig.fullscreenDialog,
      ),
    );
  }

  /// * [duration]
  /// The duration the transition going forwards.
  Future<T?>? replaceAllWithPage<T extends Object?>(
    AppPages page, {
    bool Function(Route<dynamic>)? predicate,
    Map<String, dynamic>? arguments,
    Transition? transition,
    Curve? curve,
    Duration? duration,
  }) {
    final PageConfig pageConfig =
        AppPagesExtension.getPageConfig(page, arguments);

    return pushAndRemoveUntil(
      _createRoute(
        pageBuilder: pageConfig.pageBuilder,
        settings: RouteSettings(name: page.name, arguments: arguments),
        transition: transition ?? pageConfig.transition,
        transitionDuration: duration ?? pageConfig.transitionDuration,
        curve: curve ?? pageConfig.curve,
        opaque: pageConfig.opaque,
        fullscreenDialog: pageConfig.fullscreenDialog,
      ),
      predicate ?? (Route<dynamic> _) => false,
    );
  }

  void back<T>({T? result}) => pop(result);

  void backToPageName(String name) => popUntil((route) {
        if (route is DialogRoute) return false;

        String? routeName;

        if (route is MaterialPageRoute || route is PageRouteBuilder)
          routeName = route.settings.name;

        return routeName == name || routeName == _initialPageName;
      });

  void backToPage(AppPages page) => backToPageName(page.name);
}
