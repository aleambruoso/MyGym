import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mygym/models/database.dart';
import 'package:mygym/models/exercise.dart';

class InsertOne extends StatefulWidget {
  final String type;
  final Exercise ex;
  const InsertOne({Key? key, required this.type, required this.ex})
      : super(key: key);

  @override
  State<InsertOne> createState() => InsertOneState();
}

class InsertOneState extends State<InsertOne> {
  late final String type = widget.type;
  late final Exercise ex = widget.ex;
  final _formkey = GlobalKey<FormState>();
  late TextEditingController nome = (type == "edit")
      ? TextEditingController(text: ex.nome)
      : new TextEditingController();
  late TextEditingController serie = (type == "edit")
      ? TextEditingController(text: ex.serie.toString())
      : new TextEditingController();
  late TextEditingController ripetizioni = (type == "edit")
      ? TextEditingController(text: ex.ripetizioni)
      : new TextEditingController();
  late TextEditingController minuti = (type == "edit")
      ? TextEditingController(
          text: ex.pausa.substring(0, ex.pausa.indexOf('/')))
      : new TextEditingController();
  late TextEditingController secondi = (type == "edit")
      ? TextEditingController(
          text: ex.pausa.substring(ex.pausa.indexOf('/') + 1, ex.pausa.length))
      : new TextEditingController();
  late TextEditingController note = (type == "edit")
      ? TextEditingController(text: ex.note)
      : new TextEditingController();

  @override
  void dispose() {
    nome.dispose();
    serie.dispose();
    ripetizioni.dispose();
    minuti.dispose();
    secondi.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFe37527),
          centerTitle: true,
          title: Text(
            "MyGym",
            style: GoogleFonts.montserrat(
              fontSize: 28.0,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: Form(
                  key: _formkey,
                  child: Column(children: [
                    TextFormField(
                      controller: nome,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Perfavore inserisci il nome dell'esercizio";
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
                        labelText: "Nome esercizio",
                        labelStyle: GoogleFonts.ptSans(
                          fontSize: 15.0,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: serie,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Perfavore inserisci il numero di serie";
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
                        suffixIcon: Icon(Ionicons.refresh_outline,
                            color: Color(0xff9e9e9e), size: 25),
                        labelText: "Numero di serie",
                        labelStyle: GoogleFonts.ptSans(
                          fontSize: 15.0,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9/x\+\-]'))
                      ],
                      controller: ripetizioni,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Perfavore inserisci il numero di ripetioni";
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
                        suffixIcon: Icon(Ionicons.repeat_outline,
                            color: Color(0xff9e9e9e), size: 25),
                        labelText: "Ripetioni",
                        labelStyle: GoogleFonts.ptSans(
                          fontSize: 15.0,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pausa",
                        style: GoogleFonts.lato(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            controller: minuti,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Perfavore inserisci i minuti";
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
                              suffixIcon: Icon(Ionicons.timer_outline,
                                  color: Color(0xff9e9e9e), size: 25),
                              labelText: "Minuti",
                              labelStyle: GoogleFonts.ptSans(
                                fontSize: 15.0,
                                color: Color(0xff707070),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Flexible(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            controller: secondi,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Perfavore inserisci i secondi";
                              } else if (int.parse(value) > 60) {
                                return "Non puoi inserire valori più alti di 60";
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
                              suffixIcon: Icon(Ionicons.timer_outline,
                                  color: Color(0xff9e9e9e), size: 25),
                              labelText: "Secondi",
                              labelStyle: GoogleFonts.ptSans(
                                fontSize: 15.0,
                                color: Color(0xff707070),
                              ),
                              errorMaxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    TextFormField(
                      controller: note,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
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
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          if (type == "edit") {
                            updateEsercizio();
                          } else {
                            saveEsercizio();
                          }
                        }
                      },
                      child: Text(
                        'Inserisci',
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ]),
                )),
          ),
        ),
      ),
    );
  }

  void saveEsercizio() async {
    Exercise exercise = Exercise(
        0,
        nome.text,
        int.parse(serie.text),
        ripetizioni.text,
        minuti.text + "/" + secondi.text,
        ex.giorno,
        ex.n_ordine,
        note.text,
        ex.schedaId);
    await MyGymDB.insertExercise(exercise);
    AchievementView(
      context,
      title: "Aggiunto!",
      subTitle: "Esercizio aggiunto con successo",
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
  }

  void updateEsercizio() async {
    if (ex.nome != nome.text ||
        ex.serie != int.parse(serie.text) ||
        ex.pausa != (minuti.text + "/" + secondi.text) ||
        ex.note != note.text) {
      Exercise exercise = Exercise(
          ex.id,
          nome.text,
          int.parse(serie.text),
          ripetizioni.text,
          minuti.text + "/" + secondi.text,
          ex.giorno,
          ex.n_ordine,
          note.text,
          ex.schedaId);
      await MyGymDB.updateExercise(exercise);
      AchievementView(
        context,
        title: "Modificato!",
        subTitle: "Esercizio modificato con successo",
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
