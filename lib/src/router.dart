part of 'main.dart';

/// See [VRouter.mode]
enum VRouterModes { hash, history }

/// This widget handles most of the routing work
/// It gives you access to the [routes] attribute where you can start
/// building your routes using [VRouteElement]s
///
/// Note that this widget also acts as a [MaterialApp] so you can pass
/// it every argument that you would expect in [MaterialApp]
class VRouter extends StatefulWidget {
  /// This list holds every possible routes of your app
  final List<VRouteElement> routes;

  /// If implemented, this becomes the default transition for every route transition
  /// except those who implement there own buildTransition
  /// Also see:
  ///   * [VRouteElement.buildTransition] for custom local transitions
  ///
  /// Note that if this is not implemented, every route which does not implement
  /// its own buildTransition will be given a default transition: this of a
  /// [MaterialPage]
  final Widget Function(Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child)? buildTransition;

  /// The duration of [VRouter.buildTransition]
  final Duration? transitionDuration;

  /// The reverse duration of [VRouter.buildTransition]
  final Duration? reverseTransitionDuration;

  /// Two router mode are possible:
  ///    - "hash": This is the default, the url will be serverAddress/#/localUrl
  ///    - "history": This will display the url in the way we are used to, without
  ///       the #. However note that you will need to configure your server to make this work.
  ///       Follow the instructions here: [https://router.vuejs.org/guide/essentials/history-mode.html#example-server-configurations]
  final VRouterModes mode;

  /// Called when a url changes, before the url is updated
  /// Return false if you don't want to redirect
  ///
  /// Note that you should consider the navigation cycle to
  /// handle this precisely, see [https://vrouter.dev/guide/Advanced/Navigation%20Control/The%20Navigation%20Cycle]
  ///
  /// Also see:
  ///   * [VRouteElement.beforeLeave] for route level beforeLeave
  ///   * [VNavigationGuard.beforeLeave] for widget level beforeLeave
  final Future<bool> Function(BuildContext context, String? from, String to,
      void Function(String historyState) saveHistoryState)? beforeLeave;

  /// This is called before the url is updated but after all beforeLeave are called
  /// Return false if you don't want to redirect
  ///
  /// Note that you should consider the navigation cycle to
  /// handle this precisely, see [https://vrouter.dev/guide/Advanced/Navigation%20Control/The%20Navigation%20Cycle]
  ///
  /// Also see:
  ///   * [VRouteElement.beforeEnter] for route level beforeEnter
  final Future<bool> Function(BuildContext context, String? from, String to)?
      beforeEnter;

  /// This is called after the url and the historyState is updated
  /// You can't prevent the navigation anymore
  /// You can get the new route parameters, and queryParameters
  ///
  /// Note that you should consider the navigation cycle to
  /// handle this precisely, see [https://vrouter.dev/guide/Advanced/Navigation%20Control/The%20Navigation%20Cycle]
  ///
  /// Also see:
  ///   * [VRouteElement.afterEnter] for route level afterEnter
  ///   * [VNavigationGuard.afterEnter] for widget level afterEnter
  final void Function(BuildContext context, String? from, String to)?
      afterEnter;

  /// Called after the [VRouteElement.onPopPage] when a pop event occurs
  /// You can use the context to call [VRouterData.of(context).push]
  /// or [VRouterData.of(context).pushNamed], if you do return true.
  /// Return true if you handled the event, false otherwise
  /// Note that returning false will trigger the default behaviour
  /// If [onSystemPop] is null, system event will trigger this method as well
  ///
  /// Note that you should consider the pop cycle to
  /// handle this precisely, see [https://vrouter.dev/guide/Advanced/Pop%20Events/onPop]
  ///
  /// Also see:
  ///   * [VRouteElement.onPop] for route level onPop
  ///   * [VNavigationGuard.onPop] for widget level onPop
  ///   * [VRouterState._defaultPop] for the default onPop
  final Future<bool> Function(BuildContext context)? onPop;

  /// Called after the [VRouteElement.onPopPage] when a system pop event occurs.
  /// This happens on android when the system back button is pressed.
  /// You can use the context to call [VRouterData.of(context).push]
  /// or [VRouterData.of(context).pushNamed], if you do return true.
  ///
  /// Return true if you handled the event, false otherwise
  ///
  /// Note that you should consider the systemPop cycle to
  /// handle this precisely, see [https://vrouter.dev/guide/Advanced/Pop%20Events/onSystemPop]
  ///
  /// Also see:
  ///   * [VRouteElement.onSystemPop] for route level onSystemPop
  ///   * [VNavigationGuard.onSystemPop] for widget level onSystemPop
  final Future<bool> Function(BuildContext context)? onSystemPop;

  VRouter({
    Key? key,
    required this.routes,
    this.beforeEnter,
    this.beforeLeave,
    this.onPop,
    this.onSystemPop,
    this.afterEnter,
    this.buildTransition,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.mode = VRouterModes.hash,
    // Bellow are the MaterialApp parameters
    this.scaffoldMessengerKey,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : super(key: key);

  @override
  VRouterState createState() => VRouterState();

  /// A key to use when building the [ScaffoldMessenger].
  ///
  /// If a [scaffoldMessengerKey] is specified, the [ScaffoldMessenger] can be
  /// directly manipulated without first obtaining it from a [BuildContext] via
  /// [ScaffoldMessenger.of]: from the [scaffoldMessengerKey], use the
  /// [GlobalKey.currentState] getter.
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// {@macro flutter.widgets.widgetsApp.backButtonDispatcher}
  final BackButtonDispatcher? backButtonDispatcher;

  /// {@macro flutter.widgets.widgetsApp.builder}
  ///
  /// Material specific features such as [showDialog] and [showMenu], and widgets
  /// such as [Tooltip], [PopupMenuButton], also require a [Navigator] to properly
  /// function.
  final TransitionBuilder? builder;

  /// {@macro flutter.widgets.widgetsApp.title}
  ///
  /// This value is passed unmodified to [WidgetsApp.title].
  final String title;

  /// {@macro flutter.widgets.widgetsApp.onGenerateTitle}
  ///
  /// This value is passed unmodified to [WidgetsApp.onGenerateTitle].
  final GenerateAppTitle? onGenerateTitle;

  /// Default visual properties, like colors fonts and shapes, for this app's
  /// material widgets.
  ///
  /// A second [darkTheme] [ThemeData] value, which is used to provide a dark
  /// version of the user interface can also be specified. [themeMode] will
  /// control which theme will be used if a [darkTheme] is provided.
  ///
  /// The default value of this property is the value of [ThemeData.light()].
  ///
  /// See also:
  ///
  ///  * [themeMode], which controls which theme to use.
  ///  * [MediaQueryData.platformBrightness], which indicates the platform's
  ///    desired brightness and is used to automatically toggle between [theme]
  ///    and [darkTheme] in [MaterialApp].
  ///  * [ThemeData.brightness], which indicates the [Brightness] of a theme's
  ///    colors.
  final ThemeData? theme;

  /// The [ThemeData] to use when a 'dark mode' is requested by the system.
  ///
  /// Some host platforms allow the users to select a system-wide 'dark mode',
  /// or the application may want to offer the user the ability to choose a
  /// dark theme just for this application. This is theme that will be used for
  /// such cases. [themeMode] will control which theme will be used.
  ///
  /// This theme should have a [ThemeData.brightness] set to [Brightness.dark].
  ///
  /// Uses [theme] instead when null. Defaults to the value of
  /// [ThemeData.light()] when both [darkTheme] and [theme] are null.
  ///
  /// See also:
  ///
  ///  * [themeMode], which controls which theme to use.
  ///  * [MediaQueryData.platformBrightness], which indicates the platform's
  ///    desired brightness and is used to automatically toggle between [theme]
  ///    and [darkTheme] in [MaterialApp].
  ///  * [ThemeData.brightness], which is typically set to the value of
  ///    [MediaQueryData.platformBrightness].
  final ThemeData? darkTheme;

  /// The [ThemeData] to use when 'high contrast' is requested by the system.
  ///
  /// Some host platforms (for example, iOS) allow the users to increase
  /// contrast through an accessibility setting.
  ///
  /// Uses [theme] instead when null.
  ///
  /// See also:
  ///
  ///  * [MediaQueryData.highContrast], which indicates the platform's
  ///    desire to increase contrast.
  final ThemeData? highContrastTheme;

  /// The [ThemeData] to use when a 'dark mode' and 'high contrast' is requested
  /// by the system.
  ///
  /// Some host platforms (for example, iOS) allow the users to increase
  /// contrast through an accessibility setting.
  ///
  /// This theme should have a [ThemeData.brightness] set to [Brightness.dark].
  ///
  /// Uses [darkTheme] instead when null.
  ///
  /// See also:
  ///
  ///  * [MediaQueryData.highContrast], which indicates the platform's
  ///    desire to increase contrast.
  final ThemeData? highContrastDarkTheme;

  /// Determines which theme will be used by the application if both [theme]
  /// and [darkTheme] are provided.
  ///
  /// If set to [ThemeMode.system], the choice of which theme to use will
  /// be based on the user's system preferences. If the [MediaQuery.platformBrightnessOf]
  /// is [Brightness.light], [theme] will be used. If it is [Brightness.dark],
  /// [darkTheme] will be used (unless it is null, in which case [theme]
  /// will be used.
  ///
  /// If set to [ThemeMode.light] the [theme] will always be used,
  /// regardless of the user's system preference.
  ///
  /// If set to [ThemeMode.dark] the [darkTheme] will be used
  /// regardless of the user's system preference. If [darkTheme] is null
  /// then it will fallback to using [theme].
  ///
  /// The default value is [ThemeMode.system].
  ///
  /// See also:
  ///
  ///  * [theme], which is used when a light mode is selected.
  ///  * [darkTheme], which is used when a dark mode is selected.
  ///  * [ThemeData.brightness], which indicates to various parts of the
  ///    system what kind of theme is being used.
  final ThemeMode? themeMode;

  /// {@macro flutter.widgets.widgetsApp.color}
  final Color? color;

  /// {@macro flutter.widgets.widgetsApp.locale}
  final Locale? locale;

  /// {@macro flutter.widgets.widgetsApp.localizationsDelegates}
  ///
  /// Internationalized apps that require translations for one of the locales
  /// listed in [GlobalMaterialLocalizations] should specify this parameter
  /// and list the [supportedLocales] that the application can handle.
  ///
  /// ```dart
  /// import 'package:flutter_localizations/flutter_localizations.dart';
  /// MaterialApp(
  ///   localizationsDelegates: [
  ///     // ... app-specific localization delegate[s] here
  ///     GlobalMaterialLocalizations.delegate,
  ///     GlobalWidgetsLocalizations.delegate,
  ///   ],
  ///   supportedLocales: [
  ///     const Locale('en', 'US'), // English
  ///     const Locale('he', 'IL'), // Hebrew
  ///     // ... other locales the app supports
  ///   ],
  ///   // ...
  /// )
  /// ```
  ///
  /// ## Adding localizations for a new locale
  ///
  /// The information that follows applies to the unusual case of an app
  /// adding translations for a language not already supported by
  /// [GlobalMaterialLocalizations].
  ///
  /// Delegates that produce [WidgetsLocalizations] and [MaterialLocalizations]
  /// are included automatically. Apps can provide their own versions of these
  /// localizations by creating implementations of
  /// [LocalizationsDelegate<WidgetsLocalizations>] or
  /// [LocalizationsDelegate<MaterialLocalizations>] whose load methods return
  /// custom versions of [WidgetsLocalizations] or [MaterialLocalizations].
  ///
  /// For example: to add support to [MaterialLocalizations] for a
  /// locale it doesn't already support, say `const Locale('foo', 'BR')`,
  /// one could just extend [DefaultMaterialLocalizations]:
  ///
  /// ```dart
  /// class FooLocalizations extends DefaultMaterialLocalizations {
  ///   FooLocalizations(Locale locale) : super(locale);
  ///   @override
  ///   String get okButtonLabel {
  ///     if (locale == const Locale('foo', 'BR'))
  ///       return 'foo';
  ///     return super.okButtonLabel;
  ///   }
  /// }
  ///
  /// ```
  ///
  /// A `FooLocalizationsDelegate` is essentially just a method that constructs
  /// a `FooLocalizations` object. We return a [SynchronousFuture] here because
  /// no asynchronous work takes place upon "loading" the localizations object.
  ///
  /// ```dart
  /// class FooLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  ///   const FooLocalizationsDelegate();
  ///   @override
  ///   Future<FooLocalizations> load(Locale locale) {
  ///     return SynchronousFuture(FooLocalizations(locale));
  ///   }
  ///   @override
  ///   bool shouldReload(FooLocalizationsDelegate old) => false;
  /// }
  /// ```
  ///
  /// Constructing a [MaterialApp] with a `FooLocalizationsDelegate` overrides
  /// the automatically included delegate for [MaterialLocalizations] because
  /// only the first delegate of each [LocalizationsDelegate.type] is used and
  /// the automatically included delegates are added to the end of the app's
  /// [localizationsDelegates] list.
  ///
  /// ```dart
  /// MaterialApp(
  ///   localizationsDelegates: [
  ///     const FooLocalizationsDelegate(),
  ///   ],
  ///   // ...
  /// )
  /// ```
  /// See also:
  ///
  ///  * [supportedLocales], which must be specified along with
  ///    [localizationsDelegates].
  ///  * [GlobalMaterialLocalizations], a [localizationsDelegates] value
  ///    which provides material localizations for many languages.
  ///  * The Flutter Internationalization Tutorial,
  ///    <https://flutter.dev/tutorials/internationalization/>.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// {@macro flutter.widgets.widgetsApp.localeListResolutionCallback}
  ///
  /// This callback is passed along to the [WidgetsApp] built by this widget.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// {@macro flutter.widgets.LocaleResolutionCallback}
  ///
  /// This callback is passed along to the [WidgetsApp] built by this widget.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// {@macro flutter.widgets.widgetsApp.supportedLocales}
  ///
  /// It is passed along unmodified to the [WidgetsApp] built by this widget.
  ///
  /// See also:
  ///
  ///  * [localizationsDelegates], which must be specified for localized
  ///    applications.
  ///  * [GlobalMaterialLocalizations], a [localizationsDelegates] value
  ///    which provides material localizations for many languages.
  ///  * The Flutter Internationalization Tutorial,
  ///    <https://flutter.dev/tutorials/internationalization/>.
  final Iterable<Locale> supportedLocales;

  /// Turns on a performance overlay.
  ///
  /// See also:
  ///
  ///  * <https://flutter.dev/debugging/#performanceoverlay>
  final bool showPerformanceOverlay;

  /// Turns on checkerboarding of raster cache images.
  final bool checkerboardRasterCacheImages;

  /// Turns on checkerboarding of layers rendered to offscreen bitmaps.
  final bool checkerboardOffscreenLayers;

  /// Turns on an overlay that shows the accessibility information
  /// reported by the framework.
  final bool showSemanticsDebugger;

  /// {@macro flutter.widgets.widgetsApp.debugShowCheckedModeBanner}
  final bool debugShowCheckedModeBanner;

  /// {@macro flutter.widgets.widgetsApp.shortcuts}
  /// {@tool snippet}
  /// This example shows how to add a single shortcut for
  /// [LogicalKeyboardKey.select] to the default shortcuts without needing to
  /// add your own [Shortcuts] widget.
  ///
  /// Alternatively, you could insert a [Shortcuts] widget with just the mapping
  /// you want to add between the [WidgetsApp] and its child and get the same
  /// effect.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return WidgetsApp(
  ///     shortcuts: <LogicalKeySet, Intent>{
  ///       ... WidgetsApp.defaultShortcuts,
  ///       LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
  ///     },
  ///     color: const Color(0xFFFF0000),
  ///     builder: (BuildContext context, Widget? child) {
  ///       return const Placeholder();
  ///     },
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  /// {@macro flutter.widgets.widgetsApp.shortcuts.seeAlso}
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// {@macro flutter.widgets.widgetsApp.actions}
  /// {@tool snippet}
  /// This example shows how to add a single action handling an
  /// [ActivateAction] to the default actions without needing to
  /// add your own [Actions] widget.
  ///
  /// Alternatively, you could insert a [Actions] widget with just the mapping
  /// you want to add between the [WidgetsApp] and its child and get the same
  /// effect.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return WidgetsApp(
  ///     actions: <Type, Action<Intent>>{
  ///       ... WidgetsApp.defaultActions,
  ///       ActivateAction: CallbackAction(
  ///         onInvoke: (Intent intent) {
  ///           // Do something here...
  ///           return null;
  ///         },
  ///       ),
  ///     },
  ///     color: const Color(0xFFFF0000),
  ///     builder: (BuildContext context, Widget? child) {
  ///       return const Placeholder();
  ///     },
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  /// {@macro flutter.widgets.widgetsApp.actions.seeAlso}
  final Map<Type, Action<Intent>>? actions;

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String? restorationScopeId;

  /// Turns on a [GridPaper] overlay that paints a baseline grid
  /// Material apps.
  ///
  /// Only available in checked mode.
  ///
  /// See also:
  ///
  ///  * <https://material.io/design/layout/spacing-methods.html>
  final bool debugShowMaterialGrid;
}

class VRouterState extends State<VRouter> {
  /// See [VRouterData.url]
  String? _url;

  /// See [VRouterData.previousUrl]
  String? _previousUrl;

  /// Those are all the pages of the current route
  /// It is computed every time the url is updated
  /// This is mainly used to see which pages are deactivated
  /// vs which ones are reused when the url changes
  List<VPage> flattenPages = [];

  /// This is a list which maps every possible path to the corresponding route
  /// by looking at every [VRouteElement] in [VRouter.routes]
  /// This is only computed once
  late final List<_VRoutePath> pathToRoutes;

  /// This is a context which contains the VRouter.
  /// It is used is VRouter.beforeLeave for example.
  late BuildContext _vRouterInformationContext;

  /// Represent the historyState of the router for the current
  /// history entry.
  /// It is used by the end user to store a global historyState
  /// rather than storing them in [VRouteElementData]
  ///
  /// It can be changed by using [VRouterData.of(context).replaceHistoryState(newState)]
  ///
  /// Also see:
  ///   * [VRouteData.historyState] if you want to use a route level
  ///      version of the historyState
  ///   * [VRouteElementData.historyState] if you want to use a local
  ///      version of the historyState
  String? _historyState;

  /// Designates the number of page we navigated since
  /// entering the app.
  /// If is only used in the web to know where we are when
  /// the user interacts with the browser instead of the app
  /// (e.g back button)
  late int serialCount;

  /// When set to true, urlToAppState will be ignored
  /// You must manually reset it to true otherwise it will
  /// be ignored forever.
  bool ignoreNextBrowserCalls = false;

  /// Those are used in the root navigator
  /// They are here to prevent breaking animations
  final GlobalKey<NavigatorState> _navigatorKey;
  final HeroController _heroController;

  /// The [VRoute] corresponding to the current url
  VRoute? vRoute;

  VRouterState()
      : _navigatorKey = GlobalKey<NavigatorState>(),
        _heroController = HeroController();

  @override
  void initState() {
    // When the app starts, the serial count is 0
    serialCount = 0;

    // Setup the url strategy
    if (widget.mode == VRouterModes.history) {
      setPathUrlStrategy();
    } else {
      setHashUrlStrategy();
    }

    // Compute every possible path
    pathToRoutes = _getRoutesFlatten(childRoutes: widget.routes);

    // If we are on the web, we listen to any unload event.
    // This allows us to call beforeLeave when the browser or the tab
    // is being closed for example
    if (kIsWeb) {
      BrowserHelpers.onBrowserBeforeUnload.listen((e) => onBeforeUnload());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleUrlHandler(
      urlToAppState:
          (BuildContext context, RouteInformation routeInformation) async {
        if (routeInformation.location != null && !ignoreNextBrowserCalls) {
          // Get the new state
          final newState = (kIsWeb)
              ? Map<String, String?>.from(jsonDecode(
                  (routeInformation.state as String?) ??
                      (BrowserHelpers.getHistoryState() ?? '{}')))
              : <String, String?>{};

          // Get the new serial count
          var newSerialCount;
          try {
            newSerialCount = int.parse(newState['serialCount'] ?? '');
            // ignore: empty_catches
          } on FormatException {}

          // Update the app with the new url
          await _updateUrl(
            routeInformation.location!,
            newState: newState,
            fromBrowser: true,
            newSerialCount: newSerialCount ?? serialCount + 1,
          );
        }
        return null;
      },
      appStateToUrl: () {
        return RouteInformation(
          location: _url ?? '/',
          state: jsonEncode({
            'serialCount': '$serialCount',
            '-2': _historyState,
            '-1': vRoute?.key.currentState?.historyState,
            for (var pages in flattenPages)
              '${pages.child.depth}':
                  pages.child.stateKey?.currentState?.historyState ??
                      pages.child.initialHistorySate,
          }),
        );
      },
      child: VRouterData(
        url: _url,
        previousUrl: _previousUrl,
        historyState: _historyState,
        updateUrl: (
          String url, {
          Map<String, String> queryParameters = const {},
          Map<String, String?> newState = const {},
          bool isUrlExternal = false,
          bool isReplacement = false,
          bool openNewTab = false,
        }) =>
            _updateUrl(
          url,
          queryParameters: queryParameters,
          newState: newState,
          isUrlExternal: isUrlExternal,
          isReplacement: isReplacement,
          openNewTab: openNewTab,
        ),
        updateUrlFromName: _updateUrlFromName,
        pop: _pop,
        systemPop: _systemPop,
        replaceHistoryState: _replaceHistoryState,
        child: Builder(
          builder: (context) {
            _vRouterInformationContext = context;

            // When the app starts, before we process the '/' route, we display
            // a CircularProgressIndicator.
            // Ideally this should never be needed, or replaced with a splash screen
            // Should we add the option ?
            return vRoute ?? Center(child: CircularProgressIndicator());
          },
        ),
      ),
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      color: widget.color,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      highContrastTheme: widget.highContrastTheme,
      highContrastDarkTheme: widget.highContrastDarkTheme,
      themeMode: widget.themeMode,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      supportedLocales: widget.supportedLocales,
      debugShowMaterialGrid: widget.debugShowMaterialGrid,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  /// A recursive function which is used to build [pathToRoutes]
  List<_VRoutePath> _getRoutesFlatten({
    required List<VRouteElement> childRoutes,
    _VRoutePath? parentVRoutePath,
  }) {
    final routesFlatten = <_VRoutePath>[];
    final parentPath = parentVRoutePath?.path ?? '';
    var parentVRouteElements = List<VRouteElement>.from(
        parentVRoutePath?.vRouteElements ?? <VRouteElement>[]);

    // For each childRoutes
    for (var childRoute in childRoutes) {
      // Add the VRouteElement to the parent ones to from the VRouteElements list
      final vRouteElements =
          List<VRouteElement>.from([...parentVRouteElements, childRoute]);

      // If the path is null, just get the route from the subroutes
      if (childRoute.path == null) {
        routesFlatten.addAll(
          _getRoutesFlatten(
            childRoutes: childRoute.subroutes!,
            parentVRoutePath: _VRoutePath(
              pathRegExp: parentVRoutePath?.pathRegExp,
              path: parentVRoutePath?.path,
              name: null,
              // If no path then no name
              // vRoutes: routes,
              parameters: parentVRoutePath?.parameters ?? <String>[],
              vRouteElements: vRouteElements,
            ),
          ),
        );
      } else {
        // If the path is not null

        // Get the _VRoutePath from the path

        // Get the global path
        final globalPath = (childRoute.path!.startsWith('/'))
            ? childRoute.path!
            : parentPath + childRoute.path!;

        // Get the pathRegExp and the new parameters
        var newGlobalParameters = <String>[];
        final globalPathRegExp =
            pathToRegExp(globalPath, parameters: newGlobalParameters);

        // Instantiate the new vRoutePath
        final vRoutePath = _VRoutePath(
          pathRegExp: globalPathRegExp,
          path: globalPath,
          name: childRoute.name,
          parameters: newGlobalParameters,
          vRouteElements: vRouteElements,
        );

        routesFlatten.add(vRoutePath);

        // If there is any alias
        var aliasesVRoutePath = <_VRoutePath>[];
        if (childRoute.aliases != null) {
          // Get the _VRoutePath from every alias

          for (var alias in childRoute.aliases!) {
            // Get the global path
            final globalPath =
                (alias.startsWith('/')) ? alias : parentPath + alias;

            // Get the pathRegExp and the new parameters
            var newGlobalParameters = <String>[];
            final globalPathRegExp =
                pathToRegExp(globalPath, parameters: newGlobalParameters);

            // Instantiate the new vRoutePath
            final vRoutePath = _VRoutePath(
              pathRegExp: globalPathRegExp,
              path: globalPath,
              name: childRoute.name,
              parameters: newGlobalParameters,
              vRouteElements: vRouteElements,
            );

            routesFlatten.add(vRoutePath);
            aliasesVRoutePath.add(vRoutePath);
          }
        }

        // If their is any subroute
        if (childRoute.subroutes != null && childRoute.subroutes!.isNotEmpty) {
          // Get the routes from the subroutes

          // For the path
          routesFlatten.addAll(
            _getRoutesFlatten(
              childRoutes: childRoute.subroutes!,
              parentVRoutePath: vRoutePath,
            ),
          );

          // If there is any alias
          if (childRoute.aliases != null) {
            // For the aliases
            for (var i = 0; i < childRoute.aliases!.length; i++) {
              routesFlatten.addAll(
                _getRoutesFlatten(
                  childRoutes: childRoute.subroutes!,
                  parentVRoutePath: aliasesVRoutePath[i],
                ),
              );
            }
          }
        }
      }
    }

    return routesFlatten;
  }

  /// Updates every state variables of [VRouter]
  ///
  /// Note that this does not call setState
  void updateStateVariables(
    String newUrl,
    String newPath,
    _VRoutePath vRoutePath, {
    required List<VPage> pages,
    required List<VPage> flattenPages,
    Map<String, String?> queryParameters = const {},
    String? routeHistoryState,
    String? historyState,
  }) {
    // Get the global parameters
    final match = vRoutePath.pathRegExp!.matchAsPrefix(newPath)!;

    final pathParameters = extract(vRoutePath.parameters, match);

    // Update the vRoute
    vRoute = VRoute(
      pathParameters: pathParameters,
      queryParameters: queryParameters as Map<String, String>,
      pages: pages,
      routerNavigatorKey: _navigatorKey,
      routerHeroController: _heroController,
      initialHistorySate: routeHistoryState,
    );

    // Update the url and the previousUrl
    _previousUrl = _url;
    _url = newUrl;

    // Update the router historyState
    _historyState = historyState;

    // Update flattenPages
    this.flattenPages = flattenPages;
  }

  /// See [VRouterData.pushNamed]
  void _updateUrlFromName(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Map<String, String?> newState = const {},
    bool isReplacement = false,
  }) {
    // Find the path corresponding to the name
    var newPath = pathToRoutes
        .firstWhere(
            (_VRoutePath vRoutePathRegexp) => (vRoutePathRegexp.name == name),
            orElse: () => throw Exception(
                'Could not find [VRouteElement] with name $name'))
        .path!;

    // Inject the given path parameters into the new path
    newPath = pathToFunction(newPath)(pathParameters);

    // Update the url with the found and completed path
    _updateUrl(newPath,
        queryParameters: queryParameters, isReplacement: isReplacement);
  }

  /// Recursive function which builds a nested representation of the given route
  /// The route is given as a list of [VRouteElement]s
  ///
  /// This function is also in charge of populating the given [flattenPages]
  /// which pages should be the same as in the nested structure
  List<VPage> _buildPagesFromVRouteClassList({
    required List<VPage> incompleteStack,
    required List<VRouteElement> vRouteElements,
    required String remainingUrl,
    int index = 0,
    required List<VPage> flattenPages,
    Map<String, String?> historyState = const {},
  }) {
    // If there is no more element in the vRouteElementList, we are done
    if (vRouteElements.isEmpty || index == vRouteElements.length) {
      return incompleteStack;
    }

    // Get the vRouteElement we are currently processing
    final vRouteElement = vRouteElements[index];

    // Get the local parameters
    // We start searching for the parameters once the url of the next VRouteClass don't start with /
    var localParameters = <String, String>{};
    var shouldSearchLocalParameters = true;
    for (var i = index + 1; i < vRouteElements.length; i++) {
      if (vRouteElements[i].path?.startsWith('/') ?? false) {
        shouldSearchLocalParameters = false;
        break;
      }
    }
    if (shouldSearchLocalParameters && vRouteElement.pathRegExp != null) {
      var localPath = vRouteElement.path!;

      // First remove any / that would be in first position
      if (remainingUrl.startsWith('/'))
        remainingUrl = remainingUrl.replaceFirst('/', '');
      if (localPath.startsWith('/'))
        localPath = localPath.replaceFirst('/', '');

      // We try to match the pathRegExp with the remainingUrl
      // This is null if a deeper-nester VRouteElement has a path
      // which starts with '/' (which means that this pathRegExp is not part
      // of the url)
      final match = vRouteElement.pathRegExp!.matchAsPrefix(remainingUrl);

      // If the previous match didn't fail, we get the remainingUrl be stripping of the
      // part of the url which matched
      if (match != null) {
        localParameters = extract(vRouteElement.parameters, match);
        remainingUrl = remainingUrl.substring(match.end);
      }
    }

    if (vRouteElement.isChild) {
      // If the next vRoute is a child we:
      //  - first remove the last added page
      //  - add back the page but put a VRouteInformation before it no that it can access the child
      //  - create the vChild inside the VRouteInformation, by creating a Navigator beneath the child
      //        this navigator is the one we want to create the pages for moving forward so we make
      //        the recursive call inside it
      final lastPage = incompleteStack.removeLast();
      final lastVRouteElementWidget = lastPage.child;
      final flattenPagesPreviousLength = flattenPages.length;
      final newVPage = VPage(
        key: vRouteElement.key ?? ValueKey(vRouteElement.path),
        name: vRouteElement.name ?? vRouteElement.path,
        buildTransition:
            vRouteElement.buildTransition ?? widget.buildTransition,
        transitionDuration:
            vRouteElement.transitionDuration ?? widget.transitionDuration,
        reverseTransitionDuration: vRouteElement.reverseTransitionDuration ??
            widget.reverseTransitionDuration,
        child: RouteElementWidget(
          stateKey: vRouteElement.stateKey,
          child: vRouteElement.widget,
          depth: index,
          pathParameters: localParameters,
          name: vRouteElement.name,
          initialHistorySate: historyState['$index'],
        ),
      );
      incompleteStack.add(
        VPage(
          key: lastPage.key,
          name: lastPage.name,
          buildTransition: lastPage.buildTransition,
          transitionDuration: lastPage.transitionDuration,
          reverseTransitionDuration: lastPage.reverseTransitionDuration,
          child: RouteElementWidget(
            stateKey: lastVRouteElementWidget.stateKey,
            child: lastVRouteElementWidget.child,
            depth: lastVRouteElementWidget.depth,
            name: lastVRouteElementWidget.name,
            pathParameters: lastVRouteElementWidget.pathParameters,
            initialHistorySate: lastVRouteElementWidget.initialHistorySate,
            vChildName: vRouteElement.name,
            vChild: VRouterHelper(
              observers: [vRouteElements[index - 1].heroController!],
              key: vRouteElements[index - 1].navigatorKey,
              pages: _buildPagesFromVRouteClassList(
                incompleteStack: [newVPage],
                vRouteElements: vRouteElements,
                remainingUrl: remainingUrl,
                index: index + 1,
                flattenPages: flattenPages,
                historyState: historyState,
              ),
              onPopPage: (_, __) {
                _pop();
                return false;
              },
              onSystemPopPage: () async {
                await _systemPop();
                return true;
              },
            ),
          ),
        ),
      );

      // Populate flatten pages
      // We use insert to flattenPagesPreviousLength to be sure that the order if which the
      // pages are inserted in flattenPages corresponds to the order in which VRouteElements
      // are nested
      flattenPages.insert(flattenPagesPreviousLength, newVPage);
      return incompleteStack;
    } else {
      // If the next vRoute is not a child, just add it to the stack and make a recursive call
      final newVPage = VPage(
        key: vRouteElement.key ?? ValueKey(vRouteElement.path),
        name: vRouteElement.name ?? vRouteElement.path,
        buildTransition:
            vRouteElement.buildTransition ?? widget.buildTransition,
        transitionDuration:
            vRouteElement.transitionDuration ?? widget.transitionDuration,
        reverseTransitionDuration: vRouteElement.reverseTransitionDuration ??
            widget.reverseTransitionDuration,
        child: RouteElementWidget(
          stateKey: vRouteElement.stateKey,
          child: vRouteElement.widget,
          depth: index,
          pathParameters: localParameters,
          name: vRouteElement.name,
          initialHistorySate: historyState['$index'],
        ),
      );
      incompleteStack.add(newVPage);
      flattenPages.add(newVPage);
      final finalStack = _buildPagesFromVRouteClassList(
        incompleteStack: incompleteStack,
        vRouteElements: vRouteElements,
        remainingUrl: remainingUrl,
        index: index + 1,
        flattenPages: flattenPages,
        historyState: historyState,
      );
      return finalStack;
    }
  }

  /// This should be the only way to change a url.
  /// Navigation cycle:
  ///   1. beforeLeave in all deactivated [VNavigationGuard]
  ///   2. beforeLeave in the nest-most [VRouteElement] of the current route
  ///   3. beforeLeave in the [VRouter]
  ///   4. beforeEnter in the [VRouter]
  ///   5. beforeEnter in the nest-most [VRouteElement] of the new route
  ///   The objects got in beforeLeave are stored   ///
  ///   The state of the VRouter changes            ///
  ///   6. afterEnter in the [VRouter]
  ///   7. afterEnter in the nest-most [VRouteElement] of the new route
  ///   8. afterUpdate in all reused [VNavigationGuard]
  ///   9. afterEnter in all initialized [VNavigationGuard]
  Future<void> _updateUrl(
    String newUrl, {
    Map<String, String?>? newState,
    bool fromBrowser = false,
    int? newSerialCount,
    Map<String, String> queryParameters = const {},
    bool isUrlExternal = false,
    bool isReplacement = false,
    bool openNewTab = false,
  }) async {
    assert(!kIsWeb || (!fromBrowser || newSerialCount != null));

    // This should never happen, if it does this is in error in this package
    // We take care of passing the right parameters depending on the platform
    assert(kIsWeb || isReplacement == false,
        'This does not make sense to replace the route if you are not on the web. Please set isReplacement to false.');

    newState ??= <String, String?>{};

    final newUri = Uri.parse(newUrl);
    final newPath = newUri.path;
    assert(
      !(newUri.queryParameters.isNotEmpty && queryParameters.isNotEmpty),
      'You used the queryParameters attribute but the url already contained queryParameters. The latter will be overwritten by the argument you gave',
    );
    if (queryParameters.isEmpty) {
      queryParameters = newUri.queryParameters;
    }

    // Add the queryParameters to the url if needed
    if (queryParameters.isNotEmpty) {
      newUrl = Uri(path: newPath, queryParameters: queryParameters).toString();
    }

    // Get only the path from the url
    final path = (_url != null) ? Uri.parse(_url!).path : null;

    late final List<VPage> deactivatedPages;
    late final _VRoutePath? newVRoutePathOfPath;
    late final List<VPage> reusedPages;
    late final List<VPage> newFlattenPages;
    late final List<VPage> newRouterPages;
    if (isUrlExternal) {
      deactivatedPages = List.from(flattenPages);
      reusedPages = <VPage>[];
      newVRoutePathOfPath = null;
      newFlattenPages = <VPage>[];
      newRouterPages = <VPage>[];
    } else {
      // Get the new route
      newVRoutePathOfPath = pathToRoutes.firstWhere(
          (_VRoutePath vRoutePathRegexp) =>
              vRoutePathRegexp.pathRegExp?.hasMatch(newPath) ?? false,
          orElse: () => throw InvalidUrlException(url: newUrl));

      // This copy is necessary in order not to modify vRoutePath.vRoutePathLocals
      final localInformationOfPath =
          List<VRouteElement>.from(newVRoutePathOfPath.vRouteElements);

      // Get the newRouterPages
      newFlattenPages = <VPage>[];
      newRouterPages = _buildPagesFromVRouteClassList(
        incompleteStack: [],
        vRouteElements: localInformationOfPath,
        remainingUrl: newPath,
        flattenPages: newFlattenPages,
        historyState: newState,
      );

      // Get deactivated and reused pages of the new route
      deactivatedPages = <VPage>[];
      reusedPages = <VPage>[];
      if (flattenPages.isNotEmpty) {
        for (var vPage in flattenPages.reversed) {
          try {
            newFlattenPages.firstWhere((newPage) => (newPage.key == vPage.key));
            reusedPages.add(vPage);
          } on StateError {
            deactivatedPages.add(vPage);
          }
        }
      }
    }

    var shouldSaveHistoryState = false;
    var historyStatesToSave = {
      'serialCount': '$serialCount',
      '-2': _historyState,
      '-1': vRoute?.key.currentState?.historyState,
      for (var pages in flattenPages)
        '${pages.child.depth}':
            pages.child.stateKey?.currentState?.historyState ??
                pages.child.initialHistorySate,
    };
    String? objectToSave;
    void saveHistoryState(String historyState) {
      if (objectToSave != null) {
        throw Exception(
            'You should only call saveHistoryState once.\nThis might be because you have multiple VNavigationGuard corresponding to the same VRouteElement, in that case only one of them should use saveHistoryState since the scope is the VRouteElement one.');
      }
      objectToSave = historyState;
    }

    if (_url != null) {
      ///   1. beforeLeave in all deactivated VNavigationGuard
      var shouldUpdate = true;
      for (var deactivatedPage in deactivatedPages) {
        final vNavigationGuardMessages = deactivatedPage
                .child.stateKey?.currentState?.vNavigationGuardMessages ??
            [];
        for (var vNavigationGuardMessage in vNavigationGuardMessages) {
          if (vNavigationGuardMessage.vNavigationGuard.beforeLeave != null) {
            shouldUpdate = await vNavigationGuardMessage.vNavigationGuard
                .beforeLeave!(context, _url!, newUrl, saveHistoryState);
            if (!shouldUpdate) {
              break;
            }
          }
        }
        if (!shouldUpdate) {
          break;
        } else if (objectToSave != null &&
            historyStatesToSave['${deactivatedPage.child.depth}'] !=
                objectToSave) {
          historyStatesToSave['${deactivatedPage.child.depth}'] = objectToSave;
          objectToSave = null;
          shouldSaveHistoryState = true;
        }
      }
      if (!shouldUpdate) {
        // If the url change comes from the browser, chances are the url is already changed
        // So we have to navigate back to the old url (stored in _url)
        // Note: in future version it would be better to delete the last url of the browser
        //        but it is not yet possible
        if (kIsWeb && fromBrowser && serialCount != newSerialCount) {
          ignoreNextBrowserCalls = true;
          BrowserHelpers.browserGo(serialCount - newSerialCount!);
          await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
              BrowserHelpers.getHistorySerialCount() == serialCount);
          ignoreNextBrowserCalls = false;
        }
        return;
      }

      ///   2. beforeLeave in the nest-most [VRouteElement] of the current route
      ///   saving the [VRoute] history state if needed
      // Get the actual route
      final vRoutePathOfPath = pathToRoutes.firstWhere(
          (_VRoutePath vRoutePathRegexp) =>
              vRoutePathRegexp.pathRegExp?.hasMatch(path!) ?? false,
          orElse: () => throw InvalidUrlException(url: path!));

      // Call the nest-most VRouteClass of the current route
      final vRouteElement = vRoutePathOfPath.vRouteElements.last;
      if (vRouteElement.beforeLeave != null) {
        shouldUpdate = await vRouteElement.beforeLeave!(
            context, _url!, newUrl, saveHistoryState);
        if (objectToSave != null && historyStatesToSave['-1'] != objectToSave) {
          historyStatesToSave['-1'] = objectToSave;
          objectToSave = null;
          shouldSaveHistoryState = true;
        }
        if (!shouldUpdate) {
          // If the url change comes from the browser, chances are the url is already changed
          // So we have to navigate back to the old url (stored in _url)
          // Note: in future version it would be better to delete the last url of the browser
          //        but it is not yet possible
          if (kIsWeb && fromBrowser && serialCount != newSerialCount) {
            ignoreNextBrowserCalls = true;
            BrowserHelpers.browserGo(serialCount - newSerialCount!);
            await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
                BrowserHelpers.getHistorySerialCount() == serialCount);
            ignoreNextBrowserCalls = false;
          }
          return;
        }
      }

      ///   3. beforeLeave in the VRouter
      if (widget.beforeLeave != null) {
        final shouldUpdate = await widget.beforeLeave!(
            _vRouterInformationContext, _url!, newUrl, saveHistoryState);
        if (objectToSave != null && historyStatesToSave['-2'] != objectToSave) {
          historyStatesToSave['-2'] = objectToSave;
          objectToSave = null;
          shouldSaveHistoryState = true;
        }
        if (!shouldUpdate) {
          // If the url change comes from the browser, chances are the url is already changed
          // So we have to navigate back to the old url (stored in _url)
          // Note: in future version it would be better to delete the last url of the browser
          //        but it is not yet possible
          if (kIsWeb && fromBrowser && serialCount != newSerialCount) {
            ignoreNextBrowserCalls = true;
            BrowserHelpers.browserGo(serialCount - newSerialCount!);
            await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
                BrowserHelpers.getHistorySerialCount() == serialCount);
            ignoreNextBrowserCalls = false;
          }
          return;
        }
      }
    }

    if (!isUrlExternal) {
      ///   4. beforeEnter in the VRouter
      if (widget.beforeEnter != null) {
        final shouldUpdate =
            await widget.beforeEnter!(_vRouterInformationContext, _url, newUrl);
        if (!shouldUpdate) {
          // If the url change comes from the browser, chances are the url is already changed
          // So we have to navigate back to the old url (stored in _url)
          // Note: in future version it would be better to delete the last url of the browser
          //        but it is not yet possible
          if (kIsWeb && fromBrowser && serialCount != newSerialCount) {
            ignoreNextBrowserCalls = true;
            BrowserHelpers.browserGo(serialCount - newSerialCount!);
            await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
                BrowserHelpers.getHistorySerialCount() == serialCount);
            ignoreNextBrowserCalls = false;
          }
          return;
        }
      }

      ///   5. beforeEnter in the nest-most [VRouteElement] of the new route

      // Call the nest-most VRouteClass of the new route
      // Check the local beforeEnter
      if (newVRoutePathOfPath!.vRouteElements.last.beforeEnter != null) {
        final shouldUpdate = await newVRoutePathOfPath.vRouteElements.last
            .beforeEnter!(_vRouterInformationContext, _url, newUrl);
        if (!shouldUpdate) {
          // If the url change comes from the browser, chances are the url is already changed
          // So we have to navigate back to the old url (stored in _url)
          // Note: in future version it would be better to delete the last url of the browser
          //        but it is not yet possible
          if (kIsWeb && fromBrowser && serialCount != newSerialCount) {
            ignoreNextBrowserCalls = true;
            BrowserHelpers.browserGo(serialCount - newSerialCount!);
            await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
                BrowserHelpers.getHistorySerialCount() == serialCount);
            ignoreNextBrowserCalls = false;
          }
          return;
        }
      }
    }

    final oldSerialCount = serialCount;
    if (shouldSaveHistoryState &&
        path != null &&
        historyStatesToSave.isNotEmpty) {
      assert(
        kIsWeb,
        'Tried to store the state $historyStatesToSave while not on the web. State saving/restoration only work on the web.\n'
        'You can safely ignore this message if you just want this functionality on the web.',
      );

      ///   The historyStates got in beforeLeave are stored   ///
      // If we come from the browser, chances are we already left the page
      // So we need to:
      //    1. Go back to where we were
      //    2. Save the historyState
      //    3. And go back again to the place
      if (kIsWeb && fromBrowser && oldSerialCount != newSerialCount) {
        ignoreNextBrowserCalls = true;
        BrowserHelpers.browserGo(oldSerialCount - newSerialCount!);
        await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
            BrowserHelpers.getHistorySerialCount() == oldSerialCount);
      }
      serialCount = newSerialCount ?? serialCount + 1;
      BrowserHelpers.replaceHistoryState(jsonEncode(historyStatesToSave));
      if (kIsWeb && fromBrowser && oldSerialCount != newSerialCount) {
        BrowserHelpers.browserGo(newSerialCount! - oldSerialCount);
        await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
            BrowserHelpers.getHistorySerialCount() == newSerialCount);
        ignoreNextBrowserCalls = false;
      }
    } else {
      serialCount = newSerialCount ?? serialCount + 1;
    }

    /// Leave if the url is external
    if (isUrlExternal) {
      ignoreNextBrowserCalls = true;
      await BrowserHelpers.pushExternal(newUrl, openNewTab: openNewTab);
      return;
    }

    ///   The state of the VRouter changes            ///
    // Add the new serial count to the state
    newState.addAll({'serialCount': '$serialCount'});
    final oldUrl = _url;
    final newRouterState = newState['-2'];
    if (_url != newUrl || newRouterState != _historyState) {
      updateStateVariables(
        newUrl,
        newPath,
        newVRoutePathOfPath!,
        historyState: newRouterState,
        pages: newRouterPages,
        flattenPages: newFlattenPages,
        queryParameters: queryParameters,
        routeHistoryState: newState['-1'],
      );
      if (isReplacement) {
        ignoreNextBrowserCalls = true;
        if (BrowserHelpers.getPathAndQuery(routerMode: widget.mode) != newUrl) {
          BrowserHelpers.pushReplacement(newUrl, routerMode: widget.mode);
          if (BrowserHelpers.getPathAndQuery(routerMode: widget.mode) !=
              newUrl) {
            await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
                BrowserHelpers.getPathAndQuery(routerMode: widget.mode) ==
                newUrl);
          }
        }
        BrowserHelpers.replaceHistoryState(jsonEncode(newState));
        ignoreNextBrowserCalls = false;
      }
      setState(() {});
    }

    // We need to do this after rebuild as completed so that the user can have access
    // to the new state variables
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      ///   6. afterEnter in the VRouter
      if (widget.afterEnter != null) {
        widget.afterEnter!(_vRouterInformationContext, oldUrl, newUrl);
      }

      ///   7. afterEnter in the nest-most VRouteClass of the new route
      if (newVRoutePathOfPath!.vRouteElements.last.afterEnter != null) {
        newVRoutePathOfPath.vRouteElements.last.afterEnter!(
            _vRouterInformationContext, oldUrl, newUrl);
      }

      ///   8. afterUpdate in all reused vRouteElement
      for (var vPage in reusedPages) {
        final vNavigationMessages =
            vPage.child.stateKey?.currentState?.vNavigationGuardMessages ?? [];
        for (var vNavigationMessage in vNavigationMessages) {
          if (vNavigationMessage.vNavigationGuard.afterUpdate != null) {
            vNavigationMessage.vNavigationGuard.afterUpdate!(
              vNavigationMessage.localContext,
              oldUrl,
              newUrl,
            );
          }
        }
      }

      ///   9. afterEnter in all initialized vRouteElement
      // This is done automatically by VNotificationGuard
    });
  }

  /// See [VRouterData.onPop]
  Future<void> _pop() async {
    assert(_url != null);

    final path = Uri.parse(_url!).path;

    /// Call onPop in all active VNavigationGuards
    for (var page in flattenPages.reversed) {
      final vNavigationMessages =
          page.child.stateKey?.currentState?.vNavigationGuardMessages ?? [];
      for (var vNavigationMessage in vNavigationMessages.reversed) {
        if (vNavigationMessage.vNavigationGuard.onPop != null) {
          final shouldPop = await vNavigationMessage
              .vNavigationGuard.onPop!(vNavigationMessage.localContext);
          if (!shouldPop) {
            return;
          }
        }
      }
    }

    /// Call onPop of the nested-most VRouteElement
    // Get the current route
    final vRoutePathLocals = pathToRoutes
        .firstWhere(
            (_VRoutePath vRoutePathRegexp) =>
                vRoutePathRegexp.pathRegExp?.hasMatch(path) ?? false,
            orElse: () => throw InvalidUrlException(url: path))
        .vRouteElements;

    // Find the VRouteClass which is the deepest possible
    // having onPopPage implemented
    final vRouteElement = vRoutePathLocals.last;
    if (vRouteElement.onPop != null) {
      final shouldPop = await vRouteElement.onPop!(_vRouterInformationContext);
      if (!shouldPop) {
        return;
      }
    }

    /// Call onPop of VRouter
    if (widget.onPop != null) {
      final shouldPop = await widget.onPop!(_vRouterInformationContext);
      if (!shouldPop) {
        return;
      }
    }

    /// Call default onPop
    _defaultPop();
  }

  /// See [VRouterData.systemPop]
  Future<void> _systemPop() async {
    assert(_url != null);

    final path = Uri.parse(_url!).path;

    /// Call onSystemPop in all active VNavigationGuards
    for (var page in flattenPages.reversed) {
      final vNavigationMessages =
          page.child.stateKey?.currentState?.vNavigationGuardMessages ?? [];
      for (var vNavigationMessage in vNavigationMessages.reversed) {
        if (vNavigationMessage.vNavigationGuard.onSystemPop != null) {
          final shouldPop = await vNavigationMessage
              .vNavigationGuard.onSystemPop!(vNavigationMessage.localContext);
          if (!shouldPop) {
            return;
          }
        }
      }
    }

    /// Call onSystemPop of the nested-most VRouteElement
    // Get the current route
    final vRoutePathLocals = pathToRoutes
        .firstWhere(
            (_VRoutePath vRoutePathRegexp) =>
                vRoutePathRegexp.pathRegExp?.hasMatch(path) ?? false,
            orElse: () => throw InvalidUrlException(url: path))
        .vRouteElements;

    // Find the VRouteClass which is the deepest possible
    // having onSystemPopPage implemented
    final vRouteElement = vRoutePathLocals.last;
    if (vRouteElement.onSystemPop != null) {
      // If we did find a VRouteClass, call onSystemPopPage
      final shouldPop =
          await vRouteElement.onSystemPop!(_vRouterInformationContext);
      if (!shouldPop) {
        return;
      }
    }

    /// Call VRouter onSystemPop
    if (widget.onSystemPop != null) {
      // Call VRouter.onSystemPopPage if implemented
      final shouldPop = await widget.onSystemPop!(_vRouterInformationContext);
      if (!shouldPop) {
        return;
      }
    }

    /// Call onPop, which start a onPop cycle
    await _pop();
  }

  /// This is the default behaviour of pop which is call if no one
  /// handled a pop event or a system pop event.
  /// This methods find the closest [VRouteElement] where [VRouteElement.isChild]
  /// is false, then finds the url corresponding to this subroute and
  /// call [_updateUrl] with this url.
  /// If no such [VRouteElement] is found, we do nothing on the web but
  /// put the application on the background on mobile.
  ///
  /// We also try to preserve path parameters if possible
  /// For example
  ///   Given the path /user/:id/settings (where the 'settings' path belongs to a VStacked)
  ///   If we are on /user/bob/settings
  ///   Then a defaultPop will lead to /user/bob
  ///
  /// See:
  ///   * [VNavigationGuard.onPop] to override this behaviour locally
  ///   * [VRouteElement.onPop] to override this behaviour on a on a route level
  ///   * [VRouter.onPop] to override this behaviour on a global level
  ///   * [VNavigationGuard.onSystemPop] to override this behaviour locally
  ///                               when the call comes from the system
  ///   * [VRouteElement.onSystemPop] to override this behaviour on a route level
  ///                               when the call comes from the system
  ///   * [VRouter.onSystemPop] to override this behaviour on a global level
  ///                               when the call comes from the system
  void _defaultPop() {
    assert(_url != null);
    final path = Uri.parse(_url!).path;

    // Get the current route (we copy it to avoid modifying it)
    final vRouteElements = List<VRouteElement>.from(
      pathToRoutes
          .firstWhere(
              (_VRoutePath vRoutePathRegexp) =>
                  vRoutePathRegexp.pathRegExp?.hasMatch(path) ?? false,
              orElse: () => throw InvalidUrlException(url: path))
          .vRouteElements,
    );

    // Remove the current page
    vRouteElements.removeLast();

    // Find the vRouteElements where vRoute.isChild of the last element is false
    while (vRouteElements.isNotEmpty && vRouteElements.last.isChild) {
      vRouteElements.removeLast();
    }

    if (vRouteElements.isNotEmpty) {
      // Get the new path
      final newRawPath = vRouteElements.fold<String>(
        '/',
        (previousValue, VRouteElement vRouteElement) {
          if (vRouteElement.path == null) {
            return previousValue;
          } else if (vRouteElement.path!.startsWith('/')) {
            return vRouteElement.path!;
          } else {
            return previousValue + '/' + vRouteElement.path!;
          }
        },
      );
      final newPathRegExp = pathToRegExp(newRawPath, prefix: true);

      // Extract the newRawPath from the path using the newRawPath
      final match = newPathRegExp.matchAsPrefix(path);
      String newPath;
      if (match != null) {
        newPath = path.substring(match.start, match.end);
      } else {
        // In the case where we can't deduce the path from the start
        // of the current one, we reconstruct it with the VRouter.routes path
        // This means that any parameter won't be able to be restored,
        // this is expected since we have no way to deduce those parameters
        // from the current path
        newPath = newRawPath;
      }

      // We keep the queryParameters
      final newUrl = Uri(
              path: newPath,
              queryParameters: (vRoute?.queryParameters.isNotEmpty ?? false)
                  ? vRoute!.queryParameters
                  : null)
          .toString();

      // Update the url
      _updateUrl(newUrl);
      return;
    }

    // If we didn't find any route, we are at the bottom of the stack
    // So if we are on mobile we move the app to the background
    // TODO: use move_to_background when it moves to null safety
  }

  /// See [VRouterData.replaceHistoryState]
  void _replaceHistoryState(String newRouterState) {
    if (kIsWeb) {
      final historyState = BrowserHelpers.getHistoryState() ?? '{}';
      final historyStateMap =
          Map<String, String?>.from(jsonDecode(historyState));
      historyStateMap['-2'] = newRouterState;
      final newHistoryState = jsonEncode(historyStateMap);
      BrowserHelpers.replaceHistoryState(newHistoryState);
    }
    setState(() {
      _historyState = newRouterState;
    });
  }

  /// WEB ONLY
  /// Save the state if needed before the app gets unloaded
  /// Mind that this happens when the user enter a url manually in the
  /// browser so we can't prevent him from leaving the page
  void onBeforeUnload() async {
    if (_url == null) return;
    final newSerialCount = serialCount + 1;
    final path = Uri.parse(_url!).path;

    var historyStatesToSave = <String, String>{};
    String? objectToSave;
    void saveHistoryState(String historyState) {
      if (objectToSave != null) {
        throw Exception('You should only call saveHistoryState once');
      }
      objectToSave = historyState;
    }

    ///   1. beforeLeave in all deactivated vRouteElement
    var shouldUpdate = true;
    for (var deactivatedPage in flattenPages) {
      final vNavigationMessages = deactivatedPage
              .child.stateKey?.currentState?.vNavigationGuardMessages ??
          [];
      for (var vNavigationMessage in vNavigationMessages) {
        if (vNavigationMessage.vNavigationGuard.beforeLeave != null) {
          shouldUpdate = await vNavigationMessage.vNavigationGuard.beforeLeave!(
              context, _url, '', saveHistoryState);
          if (!shouldUpdate) {
            break;
          } else {
            if (objectToSave != null) {
              historyStatesToSave['${deactivatedPage.child.depth}'] =
                  objectToSave!;
              objectToSave = null;
            }
          }
        }
      }
    }
    if (!shouldUpdate) {
      // If the url change comes from the browser, chances are the url is already changed
      // So we have to navigate back to the old url (stored in _url)
      // Note: in future version it would be better to delete the last url of the browser
      //        but it is not yet possible
      if (serialCount != newSerialCount) {
        ignoreNextBrowserCalls = true;
        BrowserHelpers.browserGo(serialCount - newSerialCount);
        await BrowserHelpers.onBrowserPopState.firstWhere(
            (element) => BrowserHelpers.getHistorySerialCount() == serialCount);
        ignoreNextBrowserCalls = false;
      }
      return;
    }

    ///   2. beforeLeave in the nest-most [VRouteElement] of the current route
    // Get the actual route
    final vRoutePathOfPath = pathToRoutes.firstWhere(
        (_VRoutePath vRoutePathRegexp) =>
            vRoutePathRegexp.pathRegExp?.hasMatch(path) ?? false,
        orElse: () => throw InvalidUrlException(url: path));

    // Call the nest-most VRouteClass of the current route
    final vRouteElement = vRoutePathOfPath.vRouteElements.last;
    if (vRouteElement.beforeLeave != null) {
      shouldUpdate =
          await vRouteElement.beforeLeave!(context, _url, '', saveHistoryState);
      if (!shouldUpdate) {
        // If the url change comes from the browser, chances are the url is already changed
        // So we have to navigate back to the old url (stored in _url)
        // Note: in future version it would be better to delete the last url of the browser
        //        but it is not yet possible
        if (serialCount != newSerialCount) {
          ignoreNextBrowserCalls = true;
          BrowserHelpers.browserGo(serialCount - newSerialCount);
          await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
              BrowserHelpers.getHistorySerialCount() == serialCount);
          ignoreNextBrowserCalls = false;
        }
        return;
      }
    }

    ///   3. beforeLeave in the VRouter
    if (widget.beforeLeave != null) {
      final shouldUpdate = await widget.beforeLeave!(
          _vRouterInformationContext, _url, '', saveHistoryState);
      if (objectToSave != null) {
        historyStatesToSave['-2'] = objectToSave!;
        objectToSave = null;
      }
      if (!shouldUpdate) {
        // If the url change comes from the browser, chances are the url is already changed
        // So we have to navigate back to the old url (stored in _url)
        // Note: in future version it would be better to delete the last url of the browser
        //        but it is not yet possible
        if (serialCount != newSerialCount) {
          // unawaited(_restoreBrowserUrl());
          ignoreNextBrowserCalls = true;
          BrowserHelpers.browserGo(serialCount - newSerialCount);
          await BrowserHelpers.onBrowserPopState.firstWhere((element) =>
              BrowserHelpers.getHistorySerialCount() == serialCount);
          ignoreNextBrowserCalls = false;
        }
        return;
      }
    }

    if (historyStatesToSave.isNotEmpty) {
      ///   The historyStates got in beforeLeave are stored   ///
      serialCount = newSerialCount;
      BrowserHelpers.replaceHistoryState(jsonEncode(historyStatesToSave));
    }
  }
}

class VRouterData extends InheritedWidget {
  final void Function(
    String newUrl, {
    Map<String, String> queryParameters,
    Map<String, String?> newState,
    bool isUrlExternal,
    bool isReplacement,
    bool openNewTab,
  }) _updateUrl;
  final void Function(
    String name, {
    Map<String, String> pathParameters,
    Map<String, String> queryParameters,
    Map<String, String?> newState,
    bool isReplacement,
  }) _updateUrlFromName;
  final Future<void> Function() _pop;
  final Future<void> Function() _systemPop;
  final void Function(String historyState) _replaceHistoryState;

  VRouterData({
    Key? key,
    required Widget child,
    this.url,
    this.previousUrl,
    this.historyState,
    required void Function(
      String newUrl, {
      Map<String, String> queryParameters,
      Map<String, String?> newState,
      bool isUrlExternal,
      bool isReplacement,
      bool openNewTab,
    })
        updateUrl,
    required void Function(
      String name, {
      Map<String, String> pathParameters,
      Map<String, String> queryParameters,
      Map<String, String?> newState,
      bool isReplacement,
    })
        updateUrlFromName,
    required Future<void> Function() pop,
    required Future<void> Function() systemPop,
    required void Function(String historyState) replaceHistoryState,
  })   : _updateUrl = updateUrl,
        _updateUrlFromName = updateUrlFromName,
        _pop = pop,
        _systemPop = systemPop,
        _replaceHistoryState = replaceHistoryState,
        super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(VRouterData old) {
    return (old.url != url ||
        old.previousUrl != previousUrl ||
        old.historyState != historyState);
  }

  /// Url currently synced with the state
  /// This url can differ from the once of the browser if
  /// the state has been yet been updated
  final String? url;

  /// Previous url that was synced with the state
  final String? previousUrl;

  /// This state is saved in the browser history. This means that if the user presses
  /// the back or forward button on the navigator, this historyState will be the same
  /// as the last one you saved.
  ///
  /// It can be changed by using [VRouteElementWidgetData.of(context).replaceHistoryState(newState)]
  ///
  /// Also see:
  ///   * [VRouteElementData.historyState] if you want to use a local level
  ///      version of the historyState
  ///   * [VRouterData.historyState] if you want to use a router level
  ///      version of the historyState
  final String? historyState;

  /// Pushes the new route of the given url on top of the current one
  /// A path can be of one of two forms:
  ///   * stating with '/', in which case we just navigate
  ///     to the given path
  ///   * not starting with '/', in which case we append the
  ///     current path to the given one
  ///
  /// We can also specify queryParameters, either by directly
  /// putting them is the url or by providing a Map using [queryParameters]
  ///
  /// We can also put a state to the next route, this state will
  /// be a router state (this is the only kind of state that we can
  /// push) accessible with VRouterData.of(context).historyState
  void push(
    String newUrl, {
    Map<String, String> queryParameters = const {},
    String? routerState,
  }) {
    if (!newUrl.startsWith('/')) {
      if (url == null) {
        throw Exception(
            "The current url is null but you are trying to access a path which does not start with'/'.");
      }
      final currentPath = Uri.parse(url!).path;
      newUrl = currentPath + '/$newUrl';
    }

    _updateUrl(newUrl,
        queryParameters: queryParameters, newState: {'-2': routerState});
  }

  /// Updates the url given a [VRouteElement] name
  ///
  /// We can also specify path parameters to inject into the new path
  ///
  /// We can also specify queryParameters, either by directly
  /// putting them is the url or by providing a Map using [queryParameters]
  ///
  /// We can also put a state to the next route, this state will
  /// be a router state (this is the only kind of state that we can
  /// push) accessible with VRouterData.of(context).historyState
  ///
  /// After finding the url and taking charge of the path parameters
  /// it updates the url
  ///
  /// To specify a name, see [VRouteElement.name]
  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    String? routerState,
  }) {
    _updateUrlFromName(name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        newState: {'-2': routerState});
  }

  /// Replace the current one by the new route corresponding to the given url
  /// The difference with [push] is that this overwrites the current browser history entry
  /// If you are on mobile, this is the same as push
  /// Path can be of one of two forms:
  ///   * stating with '/', in which case we just navigate
  ///     to the given path
  ///   * not starting with '/', in which case we append the
  ///     current path to the given one
  ///
  /// We can also specify queryParameters, either by directly
  /// putting them is the url or by providing a Map using [queryParameters]
  ///
  /// We can also put a state to the next route, this state will
  /// be a router state (this is the only kind of state that we can
  /// push) accessible with VRouterData.of(context).historyState
  void pushReplacement(
    String newUrl, {
    Map<String, String> queryParameters = const {},
    String? routerState,
  }) {
    // If not on the web, this is the same as push
    if (!kIsWeb) {
      return push(newUrl,
          queryParameters: queryParameters, routerState: routerState);
    }

    if (!newUrl.startsWith('/')) {
      if (url == null) {
        throw Exception(
            "The current url is null but you are trying to access a path which does not start with'/'.");
      }
      final currentPath = Uri.parse(url!).path;
      newUrl = currentPath + '/$newUrl';
    }

    // Update the url, setting isReplacement to true
    _updateUrl(
      newUrl,
      queryParameters: queryParameters,
      newState: {'-2': routerState},
      isReplacement: true,
    );
  }

  /// Replace the url given a [VRouteElement] name
  /// The difference with [pushNamed] is that this overwrites the current browser history entry
  ///
  /// We can also specify path parameters to inject into the new path
  ///
  /// We can also specify queryParameters, either by directly
  /// putting them is the url or by providing a Map using [queryParameters]
  ///
  /// We can also put a state to the next route, this state will
  /// be a router state (this is the only kind of state that we can
  /// push) accessible with VRouterData.of(context).historyState
  ///
  /// After finding the url and taking charge of the path parameters
  /// it updates the url
  ///
  /// To specify a name, see [VRouteElement.name]
  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    String? routerState,
  }) {
    _updateUrlFromName(name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        newState: {'-2': routerState},
        isReplacement: true);
  }

  /// Goes to an url which is not in the app
  ///
  /// On the web, you can set [openNewTab] to true to open this url
  /// in a new tab
  void pushExternal(String newUrl, {bool openNewTab = false}) =>
      _updateUrl(newUrl, isUrlExternal: true, openNewTab: openNewTab);

  /// Starts a pop cycle
  ///
  /// Pop cycle:
  ///   1. onPop is called in all [VNavigationGuard]s
  ///   2. onPop is called in the nested-most [VRouteElement] of the current route
  ///   3. onPop is called in [VRouter]
  ///   4. Default behaviour of pop is called: [VRouterState._defaultPop]
  ///
  /// If any of the step return false, then the pop cycle stops
  void pop(BuildContext context) => _pop();

  /// Starts a systemPop cycle
  ///
  /// systemPop cycle:
  ///   1. onSystemPop is called in all VNavigationGuards
  ///   2. onSystemPop is called in the nested-most VRouteElement of the current route
  ///   3. onSystemPop is called in VRouter
  ///   4. [pop] is called
  ///
  /// If any of the step return false, then the pop cycle stops
  Future<void> systemPop(BuildContext context) => _systemPop();

  /// This replaces the current history state of [VRouterData] with given one
  void replaceHistoryState(String historyState) =>
      _replaceHistoryState(historyState);

  static VRouterData of(BuildContext context) {
    final vRouterData =
        context.dependOnInheritedWidgetOfExactType<VRouterData>();
    if (vRouterData == null) {
      throw FlutterError(
          'VRouterData.of(context) was called with a context which does not contain a VRouter.\n'
          'The context used to retrieve VRouterData must be that of a widget that '
          'is a descendant of a VRouter widget.');
    }
    return vRouterData;
  }
}