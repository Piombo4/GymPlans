import 'package:flutter/material.dart';
import 'package:gymplans/classes/exercise.dart';
import 'package:gymplans/pages/progress_page_page.dart';
import 'package:gymplans/pages/show_workouts_page.dart';
import 'package:gymplans/classes/stopwatch.dart';
import 'package:gymplans/pages/time_page.dart';
import 'package:gymplans/classes/timer.dart';
import 'package:gymplans/classes/workout.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:gymplans/models/list_provider.dart';
import 'package:gymplans/models/model.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Workout>(WorkoutAdapter());
  Hive.registerAdapter<Exercise>(ExerciseAdapter());
  var box = await Hive.openBox('myBox');
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(255, 249, 239, 1.0),
  100: Color.fromRGBO(255, 174, 30, .2),
  200: Color.fromRGBO(255, 174, 30, .3),
  300: Color.fromRGBO(255, 174, 30, .4),
  400: Color.fromRGBO(255, 174, 30, .5),
  500: Color.fromRGBO(255, 174, 30, .6),
  600: Color.fromRGBO(255, 174, 30, .7),
  700: Color.fromRGBO(255, 174, 30, .8),
  800: Color.fromRGBO(255, 174, 30, .9),
  900: Color.fromRGBO(255, 174, 30, 1.0),
};
MaterialColor myColor = MaterialColor(0xFFFFAE1E, color);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(
            child,
            maxWidth: 1200,
            minWidth: 400,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(400, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        initialRoute: "/",
        theme: ThemeData(
            fontFamily: 'Poppins',
            canvasColor: Colors.white,
            primarySwatch: myColor),
        home: RootPage());
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> pages = [
    const showWorkouts(
      key: PageStorageKey('Page1'),
    ),
    const progress_page(
      key: PageStorageKey('Page2'),
    ),
    const time_page(
      key: PageStorageKey('Page3'),
    )
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(

      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 30,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'list',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          label: 'chronometer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time_rounded),
          label: 'timer',
        )
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.black45,
      selectedItemColor: myColor[1],
      selectedIconTheme: IconThemeData(size: 35),
      unselectedIconTheme: IconThemeData(size: 30),
      onTap: _onItemTapped);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
