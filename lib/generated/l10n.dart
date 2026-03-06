// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get locale {
    return Intl.message('en', name: 'locale', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Welcome\nto`
  String get welcomeTo {
    return Intl.message('Welcome\nto', name: 'welcomeTo', desc: '', args: []);
  }

  /// `Volt`
  String get volt {
    return Intl.message('Volt', name: 'volt', desc: '', args: []);
  }

  /// `Join VOLT`
  String get joinVolt {
    return Intl.message('Join VOLT', name: 'joinVolt', desc: '', args: []);
  }

  /// `Choose how you’d like to continue`
  String get chooseContinueMethod {
    return Intl.message(
      'Choose how you’d like to continue',
      name: 'chooseContinueMethod',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Password`
  String get signInWithPassword {
    return Intl.message(
      'Sign in with Password',
      name: 'signInWithPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Continue with Facebook`
  String get continueWithFacebook {
    return Intl.message(
      'Continue with Facebook',
      name: 'continueWithFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Apple`
  String get continueWithApple {
    return Intl.message(
      'Continue with Apple',
      name: 'continueWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Your gateway to live streaming`
  String get yourGatewayTo {
    return Intl.message(
      'Your gateway to live streaming',
      name: 'yourGatewayTo',
      desc: '',
      args: [],
    );
  }

  /// `Connect with audiences worldwide through high-quality audio and video streaming`
  String get connectWorldwide {
    return Intl.message(
      'Connect with audiences worldwide through high-quality audio and video streaming',
      name: 'connectWorldwide',
      desc: '',
      args: [],
    );
  }

  /// `Go Live\nInstantly`
  String get goLiveInstantly {
    return Intl.message(
      'Go Live\nInstantly',
      name: 'goLiveInstantly',
      desc: '',
      args: [],
    );
  }

  /// `Stream with one tap`
  String get streamWithOneTap {
    return Intl.message(
      'Stream with one tap',
      name: 'streamWithOneTap',
      desc: '',
      args: [],
    );
  }

  /// `Start broadcasting to your followers with our intuitive streaming tools and real-time engagement features.`
  String get startBroadcasting {
    return Intl.message(
      'Start broadcasting to your followers with our intuitive streaming tools and real-time engagement features.',
      name: 'startBroadcasting',
      desc: '',
      args: [],
    );
  }

  /// `Build Your\nCommunity`
  String get buildYourCommunity {
    return Intl.message(
      'Build Your\nCommunity',
      name: 'buildYourCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Connect and grow`
  String get connectAndGrow {
    return Intl.message(
      'Connect and grow',
      name: 'connectAndGrow',
      desc: '',
      args: [],
    );
  }

  /// `Discover new creators, build lasting connections, and grow your audience with powerful social features.`
  String get discoverCreators {
    return Intl.message(
      'Discover new creators, build lasting connections, and grow your audience with powerful social features.',
      name: 'discoverCreators',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Your Password`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot Your Password',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address or username and we’ll send you an OTP to reset your password`
  String get forgotPasswordDescription {
    return Intl.message(
      'Enter your email address or username and we’ll send you an OTP to reset your password',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Email/Username`
  String get emailOrUsername {
    return Intl.message(
      'Email/Username',
      name: 'emailOrUsername',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email or username`
  String get enterEmailOrUsername {
    return Intl.message(
      'Enter your email or username',
      name: 'enterEmailOrUsername',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or username`
  String get invalidEmailOrUsername {
    return Intl.message(
      'Invalid email or username',
      name: 'invalidEmailOrUsername',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOtp {
    return Intl.message('Send OTP', name: 'sendOtp', desc: '', args: []);
  }

  /// `Sign in instead`
  String get signInInstead {
    return Intl.message(
      'Sign in instead',
      name: 'signInInstead',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset Successfully!`
  String get passwordResetSuccessTitle {
    return Intl.message(
      'Password Reset Successfully!',
      name: 'passwordResetSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can now use your new password to sign in to your account`
  String get passwordResetSuccessDescription {
    return Intl.message(
      'You can now use your new password to sign in to your account',
      name: 'passwordResetSuccessDescription',
      desc: '',
      args: [],
    );
  }

  /// `Back to Sign in`
  String get backToSignIn {
    return Intl.message(
      'Back to Sign in',
      name: 'backToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get enterOtp {
    return Intl.message('Enter OTP', name: 'enterOtp', desc: '', args: []);
  }

  /// `We’ve sent an OTP to the address`
  String get otpSentMessage {
    return Intl.message(
      'We’ve sent an OTP to the address',
      name: 'otpSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verifyOtp {
    return Intl.message('Verify OTP', name: 'verifyOtp', desc: '', args: []);
  }

  /// `Resend OTP?`
  String get resendOtp {
    return Intl.message('Resend OTP?', name: 'resendOtp', desc: '', args: []);
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Set the new password for your account`
  String get setNewPasswordMessage {
    return Intl.message(
      'Set the new password for your account',
      name: 'setNewPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create a password`
  String get createPassword {
    return Intl.message(
      'Create a password',
      name: 'createPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmYourPassword {
    return Intl.message(
      'Confirm your password',
      name: 'confirmYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Enter your credentials to access your account`
  String get enterCredentials {
    return Intl.message(
      'Enter your credentials to access your account',
      name: 'enterCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
  }

  /// `Start your journey`
  String get startYourJourney {
    return Intl.message(
      'Start your journey',
      name: 'startYourJourney',
      desc: '',
      args: [],
    );
  }

  /// `Step 1: Account credentials`
  String get step1AccountCredentials {
    return Intl.message(
      'Step 1: Account credentials',
      name: 'step1AccountCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Choose a username`
  String get chooseUsername {
    return Intl.message(
      'Choose a username',
      name: 'chooseUsername',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `mm/dd/yyyy`
  String get mmddyyyy {
    return Intl.message('mm/dd/yyyy', name: 'mmddyyyy', desc: '', args: []);
  }

  /// `Continue`
  String get continueWord {
    return Intl.message('Continue', name: 'continueWord', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
