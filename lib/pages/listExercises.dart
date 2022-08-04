import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:mygym/models/database.dart';
import 'package:mygym/models/exercise.dart';
import 'package:mygym/pages/insertOne.dart';
import 'package:mygym/pages/training.dart';
import 'package:page_transition/page_transition.dart';

class ListExercises extends StatefulWidget {
  final int day;
  final int id;
  final String type;
  const ListExercises(
      {Key? key, required this.day, required this.id, required this.type})
      : super(key: key);

  @override
  State<ListExercises> createState() => ListExercisesState();
}

class ListExercisesState extends State<ListExercises> {
  late final int day = widget.day;
  late final int id = widget.id;
  late final String type = widget.type;
  late int length;

  Future<List<Exercise>> getExercises() async {
    List<Exercise> temp = [];
    temp = await MyGymDB.getAllExercise(id, day);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
          actions: (type == 'create')
              ? []
              : [
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                curve: Curves.easeInOut,
                                type: PageTransitionType.fade,
                                child: ListExercises(
                                    day: day, id: id, type: 'create'),
                              )).then((value) => setState((() {})));
                        },
                        child: Icon(
                          Ionicons.create_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
        ),
        floatingActionButton: (type == 'view')
            ? null
            : FloatingActionButton.extended(
                backgroundColor: Color(0xFFe37527),
                onPressed: () async {
                  List<Exercise> temp = await getExercises();
                  int n_ordine = temp.length;
                  Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.easeInOut,
                        type: PageTransitionType.bottomToTop,
                        child: InsertOne(
                            type: "create",
                            ex: Exercise(
                                0, "", 0, "", "", day, n_ordine, "", id)),
                      )).then((_) => setState(
                        () {},
                      ));
                },
                focusColor: Colors.black,
                icon: Icon(
                  Ionicons.add_circle_outline,
                  color: Colors.white,
                  size: 30,
                ),
                label: Text(
                  "Aggiungi",
                  style: GoogleFonts.montserrat(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.08,
              ),
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
    length = data.length;
    for (var i = 0; i < data.length; i++) {
      panels.add(getElement(context, data[i]));
      panels.add(SizedBox(
        height: MediaQuery.of(context).size.height * 0.03,
      ));
    }
    if (panels.isEmpty) {
      panels.add(Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Nessun elemento presente',
                style: GoogleFonts.montserrat(
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ))));
    }
    return panels;
  }

  Widget getElement(context, Exercise ex) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (type == "create") {
            Dialogs.bottomMaterialDialog(
                msg: 'Vuoi modificare questa scheda o eliminarla?',
                title: 'Modifica',
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
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.bottomToTop,
                            child: InsertOne(type: "edit", ex: ex),
                          )).then((_) => setState((() {})));
                    },
                    text: 'Modifica',
                    iconData: Ionicons.create_outline,
                    color: Color(0xffdf752c),
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                  IconsButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Dialogs.materialDialog(
                          msg: 'Sei sicuro? Non potrai più tornare indietro',
                          title: "Elimina",
                          color: Colors.white,
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
                                deleteExercise(ex.id);
                                setState(() {
                                  AchievementView(
                                    context,
                                    title: "Eliminata!",
                                    subTitle: "Scheda eliminata con successo",
                                    icon: Icon(
                                      Ionicons.checkmark_outline,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    typeAnimationContent:
                                        AnimationTypeAchievement
                                            .fadeSlideToLeft,
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.red,
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
                                });
                              },
                              text: 'Elimina',
                              iconData: Icons.delete,
                              color: Colors.red,
                              textStyle: TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ]);
                    },
                    text: 'Elimina',
                    iconData: Icons.delete,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ]);
          } else if (type == "view") {
            Dialogs.bottomMaterialDialog(
                msg: 'Vuoi iniziare ad allenarti da qui?',
                title: 'Inizia!',
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
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.bottomToTop,
                            child: Training(
                                day: day, id: id, startPoint: ex.n_ordine),
                          ));
                      //vai alla pagina di inizio allenamento
                    },
                    text: 'Inizia',
                    iconData: Ionicons.checkmark_outline,
                    color: Color(0xffdf752c),
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ]);
          }
        },
        onLongPress: () {
          if (type == "create" && length > 1) {
            Dialogs.bottomMaterialDialog(
                msg: 'Vuoi spostare questo esercizio?',
                title: 'Sposta',
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
                  if (ex.n_ordine != 0)
                    IconsButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await moveUp(ex);
                        setState(() {});
                      },
                      text: 'Sposta su',
                      iconData: Ionicons.chevron_up_outline,
                      color: Color(0xffdf752c),
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  if (ex.n_ordine != length - 1)
                    IconsButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await moveDown(ex);
                        setState(() {});
                      },
                      text: 'Sposta giù',
                      iconData: Ionicons.chevron_down_outline,
                      color: Color(0xffdf752c),
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                ]);
          } else if (type == "view") {
            Dialogs.bottomMaterialDialog(
                msg: 'Vuoi modificare questa scheda o eliminarla?',
                title: 'Modifica',
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
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.bottomToTop,
                            child: InsertOne(type: "edit", ex: ex),
                          )).then((_) => setState((() {})));
                    },
                    text: 'Modifica',
                    iconData: Ionicons.create_outline,
                    color: Color(0xffdf752c),
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                  IconsButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Dialogs.materialDialog(
                          msg: 'Sei sicuro? Non potrai più tornare indietro',
                          title: "Elimina",
                          color: Colors.white,
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
                                deleteExercise(ex.id);
                                setState(() {
                                  AchievementView(
                                    context,
                                    title: "Eliminata!",
                                    subTitle: "Scheda eliminata con successo",
                                    icon: Icon(
                                      Ionicons.checkmark_outline,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    typeAnimationContent:
                                        AnimationTypeAchievement
                                            .fadeSlideToLeft,
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.red,
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
                                });
                              },
                              text: 'Elimina',
                              iconData: Icons.delete,
                              color: Colors.red,
                              textStyle: TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ]);
                    },
                    text: 'Elimina',
                    iconData: Icons.delete,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ]);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: [0.03, 0.03], colors: [Color(0xffdf752c), Colors.white]),
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
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nome",
                        style: GoogleFonts.montserrat(
                          fontSize: 15.0,
                          color: Color(0xff545454),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ex.nome,
                          style: GoogleFonts.lato(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Note",
                          style: GoogleFonts.montserrat(
                            fontSize: 15.0,
                            color: Color(0xff545454),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ex.note,
                          style: GoogleFonts.lato(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Serie",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15.0,
                                        color: Color(0xff545454),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ex.serie.toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 16.0,
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
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Ripetizioni",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15.0,
                                        color: Color(0xff545454),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ex.ripetizioni,
                                      style: GoogleFonts.lato(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Pausa",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15.0,
                                        color: Color(0xff545454),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ex.pausa.substring(
                                              0, ex.pausa.indexOf("/")) +
                                          "'" +
                                          ex.pausa.substring(
                                              ex.pausa.indexOf("/") + 1,
                                              ex.pausa.length) +
                                          "''",
                                      style: GoogleFonts.lato(
                                          fontSize: 16.0,
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void deleteExercise(int id) async {
    await MyGymDB.deleteExercise(id);
  }

  Future<void> moveUp(Exercise exercise) async {
    await MyGymDB.changePosition(
        exercise.n_ordine, exercise.n_ordine - 1, exercise.schedaId);
  }

  Future<void> moveDown(Exercise exercise) async {
    await MyGymDB.changePosition(
        exercise.n_ordine + 1, exercise.n_ordine, exercise.schedaId);
  }
}
