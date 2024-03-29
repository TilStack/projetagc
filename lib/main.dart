import 'package:flutter/material.dart';
import 'package:projectagc/components/routes/custum_route.dart';
import 'package:projectagc/components/screens/homePage/homeClientPage.dart';
import 'package:projectagc/components/screens/navigationPage/navigationPage.dart';
import 'package:projectagc/services/localisation/localisation.dart';
import 'package:projectagc/services/providers/providerCustumer.dart';
import 'package:projectagc/services/providers/providerUser.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projectagc/services/themes/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'services/localisation/localization_constant.dart';
import 'services/providers/providerBpc.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setlocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  @override
  void initState() {
    //AuthProvider().logOutUser();
    super.initState();
    Future.delayed(Duration(seconds: 5))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  void setlocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((value) {
      setState(() {
        this._locale = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) {
              return AuthProvider();
            },
          ),
          ChangeNotifierProvider(
            create: (_) {
              return BPCProvider();
            },
          ),
          ChangeNotifierProvider(
            create: (_) {
              return ProviderCustumer();
            },
          ),
        ],
        child: Consumer<ProviderCustumer>(
          builder: (context, auth, _) {
            return AdaptiveTheme(
              light: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: blue_color,
                  hintColor: scaffoldbackground),
              dark: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: scaffoldbackground,
                  hintColor: blue_color),
              initial: AdaptiveThemeMode.light,
              builder: (theme, darktheme) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  darkTheme: darktheme,
                  locale: _locale,
                  title: 'Agc santé',
                  home: auth.isAuth == true
                      ? HomeClientPage()
                      : FutureBuilder<bool>(
                          future: auth.tryAutoLogin(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Scaffold(
                                  backgroundColor: Colors.white,
                                  body: Center(
                                    child: CircularProgressIndicator(
                                      color: blue_color,
                                    ),
                                  ),
                                );
                              case ConnectionState.none:
                                return NavigationPage();
                              default:
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return NavigationPage();
                                }
                            }
                          },
                        ),
                  supportedLocales: [
                    Locale('fr', 'FR'),
                    Locale('en', 'US'),
                  ],
                  localizationsDelegates: [
                    DemoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    for (var locale in supportedLocales) {
                      if (locale.languageCode == deviceLocale!.languageCode &&
                          locale.countryCode == deviceLocale.countryCode) {
                        return deviceLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  onGenerateRoute: CustomRoute.allRoutes,
                );
              },
            );
          },
        ),
      );
    }
  }
}
