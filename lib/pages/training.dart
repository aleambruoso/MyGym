import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:mygym/models/database.dart';
import 'package:mygym/models/exercise.dart';

class Training extends StatefulWidget {
  final int day;
  final int id;
  final int startPoint;
  const Training(
      {Key? key, required this.day, required this.id, required this.startPoint})
      : super(key: key);

  @override
  State<Training> createState() => TrainingState();
}

class TrainingState extends State<Training> {
  late final int day = widget.day;
  late final int id = widget.id;
  late final int startPoint = widget.startPoint;
  int counter = 0;
  int indexCounter = 0;
  late int index;
  int stato = 0;
  int secondi = 0;
  TextEditingController note = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final CountDownController _timer = CountDownController();

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  Future<List<Exercise>> getExercises() async {
    List<Exercise> temp = [];
    temp = await MyGymDB.getAllExerciseFromPoint(id, day, startPoint);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _willPop();
              },
            ),
            centerTitle: true,
            title: Text(
              "MyGym",
              style: GoogleFonts.montserrat(
                fontSize: 28.0,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            backgroundColor: Color(0xFFe37527),
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: FutureBuilder(
                future: getExercises(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: Color(0xffDF752C),
                      strokeWidth: 5,
                    );
                  } else {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                            left: MediaQuery.of(context).size.width * 0.05),
                        child: Column(
                          children: _getPanel(context, snapshot.data),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator(
                        color: Color(0xffDF752C),
                        strokeWidth: 5,
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getPanel(BuildContext context, data) {
    List<Widget> panels = [];
    index = data.length;

    if (stato == 1) {
      Exercise temp = data[indexCounter];
      panels.add(getElementInverse(context, temp));
    } else {
      Exercise temp = data[indexCounter];
      panels.add(getElement(context, temp));
    }

    return panels;
  }

  Widget getElement(BuildContext context, Exercise exercise) {
    if (note.text == "" || note.text == exercise.note) {
      note.text = exercise.note;
    }
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: [0.03, 0.03],
                    colors: [Color(0xffdf752c), Colors.white]),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 3.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nome",
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        color: Color(0xff545454),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.008,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        exercise.nome,
                        style: GoogleFonts.lato(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Serie",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  color: Color(0xff545454),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.008,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (exercise.serie - counter).toString(),
                                  style: GoogleFonts.lato(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Ripetizioni",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  color: Color(0xff545454),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.008,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  exercise.ripetizioni,
                                  style: GoogleFonts.lato(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: note,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      suffixIcon: Icon(Ionicons.create_outline,
                          color: Color(0xff9e9e9e), size: 30),
                      labelText: "Note",
                      labelStyle: GoogleFonts.ptSans(
                        fontSize: 20.0,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        saveNote(exercise);
                      }
                    },
                    child: Text(
                      'Salva nota',
                      style: GoogleFonts.lato(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.45,
                            MediaQuery.of(context).size.height * 0.06),
                        alignment: Alignment.center,
                        primary: Color(0xffdf752c),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23))),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            if (stato != -1)
              CircularCountDownTimer(
                duration: Duration(
                        minutes: int.parse(exercise.pausa
                            .substring(0, exercise.pausa.indexOf("/"))))
                    .inSeconds,
                fillColor: Color(0xffdf752c),
                ringColor: Colors.white,
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.8,
                isReverse: true,
                autoStart: (stato == 1) ? true : false,
                controller: _timer,
                isReverseAnimation: false,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                textStyle: GoogleFonts.montserrat(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onComplete: () {
                  if (exercise.serie - counter == 2 &&
                      index - indexCounter == 1) {
                    setState(() {
                      counter++;
                      stato = -1;
                    });
                  } else {
                    setState(() {
                      counter++;
                    });
                  }
                },
              ),
            if (stato != -1)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            if (stato != -1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (exercise.serie - counter == 1) {
                            setState(() {
                              stato = 1;
                              secondi = Duration(
                                      minutes: int.parse(exercise.pausa
                                          .substring(
                                              0, exercise.pausa.indexOf("/"))))
                                  .inSeconds;
                              counter = 0;
                              indexCounter++;
                            });
                          } else {
                            if (_timer.isStarted) {
                              _timer.resume();
                            } else {
                              _timer.start();
                            }
                          }
                        },
                        child: Text(
                          'Avvia',
                          style: GoogleFonts.lato(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: Color(0xffdf752c),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23))),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          _timer.pause();
                        },
                        child: Text(
                          'Pausa',
                          style: GoogleFonts.lato(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23))),
                      ),
                    ),
                  ),
                ],
              ),
            if (stato == -1)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            if (stato == -1)
              ElevatedButton.icon(
                icon: Icon(
                  Ionicons.exit_outline,
                  color: Colors.white,
                  size: 20,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.06),
                  alignment: Alignment.center,
                  primary: Color(0xffdf752c),
                ),
                onPressed: () {
                  _willPop();
                },
                label: Text(
                  'Esci',
                  style: GoogleFonts.lato(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ));
  }

  Widget getElementInverse(BuildContext context, Exercise exercise) {
    note = TextEditingController(text: exercise.note);
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          children: [
            CircularCountDownTimer(
              duration: secondi,
              fillColor: Color(0xffdf752c),
              ringColor: Colors.white,
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.5,
              isReverse: true,
              autoStart: (stato == 1) ? true : false,
              controller: _timer,
              isReverseAnimation: false,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              textStyle: GoogleFonts.montserrat(
                fontSize: 36.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              onComplete: () {
                setState(() {
                  stato = 0;
                });
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        _timer.resume();
                      },
                      child: Text(
                        'Avvia',
                        style: GoogleFonts.lato(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          primary: Color(0xffdf752c),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23))),
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        _timer.pause();
                      },
                      child: Text(
                        'Pausa',
                        style: GoogleFonts.lato(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23))),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: [0.03, 0.03],
                    colors: [Color(0xffdf752c), Colors.white]),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 3.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nome",
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        color: Color(0xff545454),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.008,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        exercise.nome,
                        style: GoogleFonts.lato(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Serie",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  color: Color(0xff545454),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.008,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (exercise.serie - counter).toString(),
                                  style: GoogleFonts.lato(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Ripetizioni",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  color: Color(0xff545454),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.008,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  exercise.ripetizioni,
                                  style: GoogleFonts.lato(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: note,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      suffixIcon: Icon(Ionicons.create_outline,
                          color: Color(0xff9e9e9e), size: 30),
                      labelText: "Note",
                      labelStyle: GoogleFonts.ptSans(
                        fontSize: 20.0,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        saveNote(exercise);
                      }
                    },
                    child: Text(
                      'Salva nota',
                      style: GoogleFonts.lato(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.45,
                            MediaQuery.of(context).size.height * 0.06),
                        alignment: Alignment.center,
                        primary: Color(0xffdf752c),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23))),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            /*Duration(
                    minutes: int.parse(exercise.pausa
                        .substring(0, exercise.pausa.indexOf("/"))))*/
          ],
        ));
  }

  Future<bool> _willPop() async {
    bool ret = false;
    Dialogs.bottomMaterialDialog(
        msg: 'Vuoi uscire dall\'allenamento?',
        title: 'Esci',
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Annulla',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.black),
            iconColor: Colors.black,
          ),
          IconsButton(
            onPressed: () {
              Navigator.pop(context);
              AchievementView(
                context,
                title: "Interroto!",
                subTitle: "L'allenamento è stato interrotto",
                icon: Icon(
                  Ionicons.exit_outline,
                  color: Colors.white,
                  size: 30,
                ),
                typeAnimationContent: AnimationTypeAchievement.fadeSlideToLeft,
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffdf752c),
                textStyleTitle: GoogleFonts.montserrat(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textStyleSubTitle: GoogleFonts.lato(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                alignment: Alignment.topCenter,
                duration: Duration(seconds: 2),
              ).show();
              Navigator.pop(context);
            },
            text: 'Esci',
            iconData: Ionicons.exit_outline,
            color: Color(0xffdf752c),
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
    return ret;
  }

  Future<void> saveNote(Exercise exercise) async {
    Exercise temp = Exercise(
        exercise.id,
        exercise.nome,
        exercise.serie,
        exercise.ripetizioni,
        exercise.pausa,
        exercise.giorno,
        exercise.n_ordine,
        note.text,
        exercise.schedaId);
    MyGymDB.updateExercise(temp);
  }
}
