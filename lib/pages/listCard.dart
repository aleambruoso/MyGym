import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:mygym/models/database.dart';
import 'package:mygym/models/gymCard.dart';
import 'package:mygym/pages/choiceDay.dart';
import 'package:mygym/pages/newCard.dart';
import 'package:page_transition/page_transition.dart';

class ListCard extends StatefulWidget {
  const ListCard({Key? key}) : super(key: key);

  @override
  State<ListCard> createState() => ListCardState();
}

class ListCardState extends State<ListCard> {
  Future<List<GymCard>> getGymCards() async {
    List<GymCard> temp = [];
    temp = await MyGymDB.getAllCards();
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
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: FutureBuilder(
            future: getGymCards(),
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
    );
  }

  List<Widget> _getPanel(BuildContext context, data) {
    List<Widget> panels = [];
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

  Widget getElement(context, GymCard card) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                curve: Curves.easeInOut,
                type: PageTransitionType.rightToLeft,
                child: ChoiceDay(type: "check", id: card.id),
              ));
        },
        onLongPress: () {
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
                          child: NewCard(type: "edit", card: card),
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
                              deleteCard(card.id);
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
                                      AnimationTypeAchievement.fadeSlideToLeft,
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
                          card.nome,
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
                          card.note,
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
            ),
          ),
        ),
      ),
    );
  }

  void deleteCard(int id) async {
    await MyGymDB.deleteCard(id);
  }
}
