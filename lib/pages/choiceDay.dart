import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/pages/listExercises.dart';
import 'package:page_transition/page_transition.dart';

class ChoiceDay extends StatefulWidget {
  final String type;
  final int id;
  const ChoiceDay({Key? key, required this.type, required this.id})
      : super(key: key);

  @override
  State<ChoiceDay> createState() => ChoiceDayState();
}

class ChoiceDayState extends State<ChoiceDay> {
  late final String type = widget.type;
  late final int id = widget.id;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (type == "create") {
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.rightToLeftWithFade,
                            child:
                                ListExercises(day: 1, id: id, type: 'create'),
                          ));
                    } else if (type == "check") {
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.rightToLeftWithFade,
                            child: ListExercises(day: 1, id: id, type: 'view'),
                          ));
                    }
                  },
                  child: Text(
                    "Giorno 1",
                    style: GoogleFonts.lato(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.5,
                          MediaQuery.of(context).size.height * 0.08),
                      alignment: Alignment.center,
                      primary: Color(0xffdf752c),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (type == "create") {
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.rightToLeftWithFade,
                            child:
                                ListExercises(day: 2, id: id, type: 'create'),
                          ));
                    } else if (type == "check") {
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.rightToLeftWithFade,
                            child: ListExercises(day: 2, id: id, type: 'view'),
                          ));
                    }
                  },
                  child: Text(
                    "Giorno 2",
                    style: GoogleFonts.lato(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.5,
                          MediaQuery.of(context).size.height * 0.08),
                      alignment: Alignment.center,
                      primary: Color(0xffdf752c),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (type == "create") {
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.rightToLeftWithFade,
                            child:
                                ListExercises(day: 3, id: id, type: 'create'),
                          ));
                    } else if (type == "check") {
                      Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.easeInOut,
                            type: PageTransitionType.rightToLeftWithFade,
                            child: ListExercises(day: 3, id: id, type: 'view'),
                          ));
                    }
                  },
                  child: Text(
                    "Giorno 3",
                    style: GoogleFonts.lato(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.5,
                          MediaQuery.of(context).size.height * 0.08),
                      alignment: Alignment.center,
                      primary: Color(0xffdf752c),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
