import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mygym/models/database.dart';
import 'package:mygym/models/gymCard.dart';
import 'package:mygym/pages/choiceDay.dart';
import 'package:page_transition/page_transition.dart';

class NewCard extends StatefulWidget {
  final String type;
  final GymCard card;
  const NewCard({Key? key, required this.type, required this.card})
      : super(key: key);

  @override
  State<NewCard> createState() => NewCardState();
}

class NewCardState extends State<NewCard> {
  late final String type = widget.type;
  late final GymCard card = widget.card;
  final _formkey = GlobalKey<FormState>();
  late TextEditingController nome = (type == "edit")
      ? TextEditingController(text: card.nome)
      : new TextEditingController();
  late TextEditingController note = (type == "edit")
      ? TextEditingController(text: card.note)
      : new TextEditingController();

  @override
  void dispose() {
    nome.dispose();
    note.dispose();
    super.dispose();
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
          child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nome,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Perfavore inserisci il nome della scheda";
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        suffixIcon: Icon(Ionicons.text_outline,
                            color: Color(0xff9e9e9e), size: 25),
                        labelText: "Nome scheda",
                        labelStyle: GoogleFonts.ptSans(
                          fontSize: 15.0,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    TextFormField(
                      controller: note,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      maxLines: 10,
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
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          (type == "edit") ? editCard() : createCard();
                        }
                      },
                      child: Text(
                        (type == "edit") ? 'Modifica' : 'Crea',
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
              )),
        ),
      ),
    );
  }

  void createCard() async {
    GymCard card = GymCard(0, nome.text, note.text);
    int id = await MyGymDB.insertCard(card);

    Navigator.pushReplacement(
        context,
        PageTransition(
          curve: Curves.easeInOut,
          type: PageTransitionType.fade,
          child: ChoiceDay(type: "create", id: id),
        ));
  }

  void editCard() async {
    if (card.nome != nome.text || card.note != note.text) {
      GymCard temp = GymCard(card.id, nome.text, note.text);
      await MyGymDB.updateCard(temp);
      AchievementView(
        context,
        title: "Modificata!",
        subTitle: "Scheda modificata con successo",
        icon: Icon(
          Ionicons.checkmark_outline,
          color: Colors.white,
          size: 30,
        ),
        typeAnimationContent: AnimationTypeAchievement.fadeSlideToLeft,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
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
    } else {
      Navigator.pop(context);
    }
  }
}
