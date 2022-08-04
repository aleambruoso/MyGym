import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mygym/models/database.dart';
import 'package:mygym/models/gymCard.dart';
import 'package:mygym/pages/listCard.dart';
import 'package:mygym/pages/newCard.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await MyGymDB.createDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyGym',
      theme: ThemeData(
        primaryColor: Color(0xFFe37527),
      ),
      home: const MyHomePage(title: 'MyGym'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    setOptimalDisplayMode();
    super.initState();
  }

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
            m.width == active.width && m.height == active.height)
        .toList()
      ..sort((DisplayMode a, DisplayMode b) =>
          b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe37527), Color(0xffFFFFFF)],
              begin: FractionalOffset(0, 0.3),
              end: const FractionalOffset(0, 4),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: Align(
                  alignment: Alignment.center,
                  child: Image(
                    width: MediaQuery.of(context).size.width * 0.5,
                    image: AssetImage('assets/iconaBianca.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "MyGym",
                    style: GoogleFonts.lato(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Ionicons.albums_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height * 0.06),
                      alignment: Alignment.center,
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.rightToLeftWithFade,
                            child: ListCard(),
                          ));
                    },
                    label: Text(
                      'Le mie schede',
                      style: GoogleFonts.lato(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.06),
                  alignment: Alignment.center,
                  primary: Color(0xff000000),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.easeInOut,
                        type: PageTransitionType.rightToLeftWithFade,
                        child:
                            NewCard(type: "create", card: GymCard(0, "", "")),
                      ));
                },
                label: Text(
                  'Crea scheda',
                  style: GoogleFonts.lato(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
