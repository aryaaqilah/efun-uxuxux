import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
// import 'package:photo_editor/screens/adjust_screen.dart';
// import 'package:photo_editor/screens/blur_screen.dart';
// import 'package:photo_editor/screens/draw_screen.dart';
// import 'package:photo_editor/screens/fit_screen.dart';
// import 'package:photo_editor/screens/home_screen.dart';
// import 'package:photo_editor/screens/mask_screen.dart';
// import 'package:photo_editor/screens/tint_screen.dart';
import 'package:photo_editor/screens/crop_screen.dart';
import 'package:photo_editor/screens/custom_frame3x1.dart';
import 'package:photo_editor/screens/filter_screen.dart';
import 'package:photo_editor/screens/save_share_screen.dart';
import 'package:photo_editor/screens/start_screen.dart';
import 'package:photo_editor/screens/sticker_screen.dart';
import 'package:photo_editor/screens/test2.dart';
import 'package:photo_editor/screens/text_screen.dart';
import 'package:photo_editor/screens/splash_screen.dart';
import 'package:photo_editor/screens/history_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppImageProvider())],
      child: const MyApp()));
  providers:
  [ChangeNotifierProvider(create: (_) => AppImageProvider())];
  child:
  const MyApp();
}

int? chosenIndex;
String? framePath;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Fun',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(244, 244, 244, 244),
          primarySwatch: Colors.blueGrey,
          appBarTheme: const AppBarTheme(
              color: Colors.black, centerTitle: true, elevation: 0),
          sliderTheme: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.always)),
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/start': (_) => const StartScreen(),
        '/history': (_) => const HistoryScreen(),
        '/layout': (_) => const ChooseLayout(),
        '/filter': (_) => const FilterScreen(),
        '/frame3x1': (_) => const ChooseFrameScreen(),
        '/sticker': (_) => const StickerTextScreen(),
        '/save': (_) => const SaveShareScreen(),
        '/text': (_) => const TextScreen(),
        // '/crop': (_) => const CropScreen(),
        // '/home': (_) => const HomeScreen(),
        // '/adjust': (_) => const AdjustScreen(),
        // '/fit': (_) => const FitScreen(),
        // '/tint': (_) => const TintScreen(),
        // '/blur': (_) => const BlurScreen(),
        // '/draw': (_) => const DrawScreen(),
        // '/mask': (_) => const MaskScreen()
      },
      initialRoute: '/', // This ensures SplashScreen is the first screen
    );
  }
}
