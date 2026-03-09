import 'dart:developer';
import 'package:ailixir/features/awards/presentation/cubits/award_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/core/cubits/app_settings/app_settings_cubit.dart';
import 'package:ailixir/core/services/navigation/app_router.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/themes/app_themes.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:ailixir/generated/l10n.dart';

class AilixirApp extends StatelessWidget {
  const AilixirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1400, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => GetIt.I<AuthCubit>()),
          BlocProvider(create: (context) => GetIt.I<AwardsCubit>()),
          BlocProvider(create: (context) => AppSettingsCubit()),
        ],
        child: const MyMaterialApp(),
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        final lang = context.read<AppSettingsCubit>().currentLanguage;
        // final lang = 'ar';
        AppTextStyles.init(Locale(lang));
        log('Did Rebuild Full App $lang');
        return MaterialApp.router(
          restorationScopeId:
              "Test", // <-- Add this line to fix windows release
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: Locale(lang),
          themeMode: ThemeMode.dark,
          darkTheme: AppThemes.getTheme(context, isDarkTheme: true),
          theme: AppThemes.getTheme(context, isDarkTheme: false),
          builder: (context, widget) {
            log('Did Rebuild App22 ${S.current.locale}');
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
