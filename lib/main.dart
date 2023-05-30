import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'di/app_binding.dart';
import 'generated/locales.g.dart';
import 'ui/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBinding().dependencies();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      translationsKeys: AppTranslation.translations,
      locale: _getDefaultLocale(),
      supportedLocales: {_getDefaultLocale()},
      fallbackLocale: _getDefaultLocale(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Locale _getDefaultLocale() => const Locale('en', 'US');
