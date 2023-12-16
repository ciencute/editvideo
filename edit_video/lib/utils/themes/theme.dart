import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../di/locator.dart';

const String dark = "dark";
const String light = "light";

ThemeData defaultTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
        backgroundColor: kNeutralLightColor[7] ?? const Color(0xFFFCFDFE),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            // Status bar color
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent)),
    iconTheme: IconThemeData(color: kNeutralLightColor[6]),
    colorScheme: ColorScheme.light(
        primary: kPrimaryColor,
        secondary: kPrimaryColor[4] ?? const Color(0xFFBE87FF),
        background: kNeutralLightColor[7] ?? const Color(0xFFFCFDFE)),
    fontFamily: kNunitoFamily,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal),
      bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.3,
          fontStyle: FontStyle.normal),
      bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal),
      bodySmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal),
      labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontStyle: FontStyle.normal),
    ).apply(
        fontFamily: kNunitoFamily,
        fontSizeFactor: 1.0,
        bodyColor: kNeutralLightColor[6],
        displayColor: kNeutralLightColor[6]),
  );
}

const String kNunitoFamily = 'Nunito';
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kBlackColor = Color(0xFF000000);

MaterialColor get kNeutralColor => kNeutralLightColor;

const kPrimaryColor = MaterialColor(0xFF0C018C, <int, Color>{
  1: Color(0xFF0C018C),
  2: Color(0xFF3331BD),
  3: Color(0xFF735FFA),
  4: Color(0xFFBE87FF),
  5: Color(0xFFDABAFF),
  6: Color(0xFFE3CBFF),
  7: Color(0xFFEBDBFF)
});

const kNeutralLightColor = MaterialColor(0xFF181B1F, <int, Color>{
  1: Color(0xFFF1F5F9),
  2: Color(0xFFE3E9EE),
  3: Color(0xFF7C878E),
  4: Color(0xFF393E44),
  5: Color(0xFF292D32),
  6: Color(0xFF181B1F),
  7: Color(0xFFFCFDFE),
});

const kAdditionColor = MaterialColor(0xFFFF3D00, <int, Color>{
  1: Color(0xFFFFC632),
  2: Color(0xFF4BAB71),
  3: Color(0xFF1F82FF),
  4: Color(0xFFFF66C2)
});

const Color kBackgroundLightColor = Color(0xFFF7F7FA);
const Color kBackgroundLight2Color = Color(0xFFF1F1F1);
const Color kPrimaryLightColor = Color(0xFFFF5C4D);
const Color kInvalidColor = Color(0xFFB8BCCC);
const Color kLoadingColor = Color(0xFF7C878E);
const Color kErrorColor = Color(0xFFFF4C6D);
const Color kSuccessColor = Color(0xFF0CAF60);
const Color kAlertColor = Color(0xFF735FFA);

const Gradient kGradient1 = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0, 0.56, 1],
    colors: [Color(0xFFFFE890), Color(0xFFF3ACFF), Color(0xFF8AECFF)]);

const Gradient kGradient2 = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xFF646DE7), Color(0xFF5360DA), Color(0xFF112184)]);
const Gradient kGradient3 =
    LinearGradient(colors: [Color(0xFFF3EEE2), Color(0xFFDEF0D6)]);
const Gradient kGradient4 =
    LinearGradient(colors: [Color(0xFFE0C6FF), Color(0xFFFFE1FA)]);
const Gradient kGradient5 =
    LinearGradient(colors: [Color(0xFFE2F3E9), Color(0xFFE0F8FF)]);
const Gradient kGradient6 =
    LinearGradient(colors: [Color(0xFFFFF2DF), Color(0xFFE7E1FF)]);
const Gradient kGradient7 =
    LinearGradient(colors: [Color(0xFF9A77FF), Color(0xFF735FFA)]);

const double kDefaultRadius = 8;
const double kDefaultRadiusMedium = 12;
const double kDefaultRadiusLarge = 16;
const double kDefaultPaddingSmall = 8;
const double kDefaultPadding = 16;
const double kDefaultPaddingMedium = 24;
const double kDefaultPaddingLarge = 32;
const double kDefaultHeight = 48;
const double kDefaultWidth = 200;

AppBar myAppBar(BuildContext context,
    {Widget? leading,
    Widget? title,
    List<Widget> actions = const [],
    centerTitle = true,
    double? leadingWidth,
    Color? color}) {
  return _myAppBar(context,
      leading: leading,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      leadingWidth: leadingWidth,
      color: color);
}

AppBar _myAppBar(BuildContext context,
    {Widget? leading,
    Widget? title,
    List<Widget> actions = const [],
    centerTitle = true,
    double? leadingWidth,
    Color? color}) {
  return AppBar(
    key: UniqueKey(),
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        // Status bar color
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent),
    leadingWidth: leadingWidth,
    leading: leading,
    scrolledUnderElevation: 0,
    backgroundColor: color,
    centerTitle: centerTitle,
    titleSpacing: 8,
    title: title,
    elevation: 0,
    actions: actions,
  );
}

AppBar myAppBarTransparent(BuildContext context,
    {Widget? leading,
    Widget? title,
    List<Widget> actions = const [],
    centerTitle = true,
    double? leadingWidth}) {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent));
  return AppBar(
    key: UniqueKey(),
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent),
    leadingWidth: leadingWidth,
    leading: leading,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: centerTitle,
    titleSpacing: 8,
    title: title,
    elevation: 0,
    actions: actions,
  );
}

Widget appbarIcon(bool isPro) => Image.asset(
      isPro
          ? 'assets/icons/ic_appbar_logo_pro.png'
          : 'assets/icons/ic_appbar_logo.png',
      fit: BoxFit.contain,
      color: kPrimaryLightColor,
    );

Widget backIcon(VoidCallback? onPressed, {Color? color}) => IconButton(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    icon: Icon(Icons.arrow_back_ios, color: color ?? kNeutralColor),
    onPressed: onPressed);

double screenPadding(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return screenSize.width <= 400 ? 16 : (screenSize.width - 400) / 2 + 12;
}

int screenMaxWithItemGrid(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return screenSize.width <= 480 ? 2 : (screenSize.width <= 720 ? 3 : 4);
}

void applySystemUIOverlay() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent));
}

TextStyle titleStyle = const TextStyle(
    fontFamily: kNunitoFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: kBackgroundLightColor);

TextStyle get titleNeutralStyle => TextStyle(
    fontFamily: kNunitoFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: themeData == ThemeMode.light ? kNeutralColor : kNeutralLightColor);
