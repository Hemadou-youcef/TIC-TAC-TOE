import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "XO GAME",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  // CLASSES CALL
  PainterLines painter = new PainterLines();
  // INFORAMATION ABOUT SCREEN SIZE
  double width;
  // THE VALUES OF THE GAME
  List<GameButtonValue> gameBuVa = <GameButtonValue>[
    new GameButtonValue(""),
    new GameButtonValue(""),
    new GameButtonValue(""),
    new GameButtonValue(""),
    new GameButtonValue(""),
    new GameButtonValue(""),
    new GameButtonValue(""),
    new GameButtonValue(""),
    new GameButtonValue(""),
  ]; // Game Button Values
  List<double> lpos = new List(4);
  List<int> pwins = new List(2);
  List<List<int>> evoMatrix = new List();
  List<int> wrongmove = new List();
  List<int> correctmove = new List();
  var moves = {0: 0, 1: 1, 2: 0, 3: 1, 4: 4, 5: 1, 6: 0, 7: 1, 8: 0};

  String statinfo = ""; // state inforamtion
  String player1p = "X"; //player 1 piece
  String player2p = "O"; //player 2 piece
  String firstplay = "";

  int lway = 0; //line way
  int turn = 1; //turn of players
  int tnumb = 0;
  int restartgp = 1;
  int ngame = 0;
  // GAME BOOLEAN STAT
  bool solo = true; //play mode solo or multiplayer
  bool px = true; //player piece X or O

  bool vxo = false; //show the playing ground
  bool dialog = false; //show the tie dialog
  bool statinfob = false; //show the text on the bottom
  bool vpainter = false; //show the line drawing
  bool vcheckbox = true; //show the checkbox

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("XO GAME")),
        backgroundColor: Color.fromRGBO(19, 38, 57, 1),
      ),
      body: SingleChildScrollView(
        child: new GestureDetector(
          onTap: () {
            setState(() {
              gamemode(0);
            });
          },
          child: Column(
            children: <Widget>[
              Visibility(
                visible: dialog,
                child: CupertinoAlertDialog(
                  title: Text("$statinfo"),
                  content: Text("P1: ${pwins[0]} WIN / P2: ${pwins[1]} WIN"),
                  actions: [
                    CupertinoDialogAction(
                      child: Text("PLAY AGAIN"),
                      onPressed: () {
                        setState(() {
                          minirestart();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: vxo,
                child: SizedBox(
                  height: width + 50,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      padding: EdgeInsets.all(10),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return new RaisedButton(
                          onPressed: () {
                            setState(() {
                              gamemode(index);
                            });
                          },
                          child: Text(
                            gameBuVa[index].str,
                            style: TextStyle(fontSize: 60, color: Colors.white),
                          ),
                          color: Color.fromRGBO(45, 89, 134, 1),
                        );
                      }),
                ),
              ),
              Visibility(
                visible: vpainter,
                child: CustomPaint(
                  painter: painter,
                  child: Container(
                    width: width,
                    height: 0,
                  ),
                ),
              ),
              Visibility(
                visible: statinfob,
                child: Center(
                  child: Text(
                    "$statinfo",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Visibility(
                visible: vcheckbox,
                child: Column(children: <Widget>[
                  CheckboxListTile(
                    selected: true,
                    title: Text("SOLO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    value: solo,
                    onChanged: (bool value) {
                      setState(() {
                        solo = true;
                      });
                    },
                  ),
                  Visibility(
                      visible: solo,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: width / 5,
                          ),
                          Transform.scale(
                            scale: 2.0,
                            child: Checkbox(
                              value: px,
                              activeColor: Colors.indigo,
                              onChanged: (bool value) {
                                setState(() {
                                  px = true;

                                  player1p = "X";
                                  player2p = "O";
                                });
                              },
                            ),
                          ),
                          Text(
                            "X",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: width / 5,
                          ),
                          Transform.scale(
                            scale: 2.0,
                            child: Checkbox(
                              value: !px,
                              activeColor: Colors.greenAccent,
                              onChanged: (bool value) {
                                setState(() {
                                  px = false;
                                  player1p = "O";
                                  player2p = "X";
                                });
                              },
                            ),
                          ),
                          Text(
                            "O",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  CheckboxListTile(
                    title: Text("MULTIPLAYER",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    value: !solo,
                    onChanged: (bool value) {
                      setState(() {
                        solo = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: !solo,
                      child: Column(children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: width / 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "PLAYER 1 ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Transform.scale(
                              scale: 2.0,
                              child: Checkbox(
                                value: px,
                                activeColor: Colors.indigo,
                                onChanged: (bool value) {
                                  setState(() {
                                    px = true;
                                    player1p = "X";
                                    player2p = "O";
                                  });
                                },
                              ),
                            ),
                            Text(
                              "X",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Transform.scale(
                              scale: 2.0,
                              child: Checkbox(
                                value: !px,
                                activeColor: Colors.greenAccent,
                                onChanged: (bool value) {
                                  setState(() {
                                    px = false;
                                    player1p = "O";
                                    player2p = "X";
                                  });
                                },
                              ),
                            ),
                            Text(
                              "O",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: width / 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "PLAYER 2 ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Transform.scale(
                              scale: 2.0,
                              child: Checkbox(
                                value: !px,
                                activeColor: Colors.indigo,
                                onChanged: (bool value) {
                                  setState(() {
                                    px = false;
                                    player1p = "O";
                                    player2p = "X";
                                  });
                                },
                              ),
                            ),
                            Text(
                              "X",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Transform.scale(
                              scale: 2.0,
                              child: new Checkbox(
                                value: px,
                                activeColor: Colors.greenAccent,
                                onChanged: (bool value) {
                                  setState(() {
                                    px = true;
                                    player1p = "X";
                                    player2p = "O";
                                  });
                                },
                              ),
                            ),
                            Text(
                              "O",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ])),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        if (evoMatrix.length == 0) {
                          evoMatrix.add(new List());
                        } else {
                          if (evoMatrix[ngame].length != 0) {
                            evoMatrix.add(new List());
                          }
                        }

                        pwins[0] = 0;
                        pwins[1] = 0;
                        vxo = true;
                        statinfob = true;
                        vpainter = true;
                        vcheckbox = false;
                        dialog = false;
                      });
                    },
                    child: Text("PLAY"),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            restart();
          });
        },
        child: Text("RESET"),
        backgroundColor: Color.fromRGBO(19, 38, 57, 1),
      ),
    );
  }

  // BASICS FUNCTION
  bool checker(String piece) {
    //checker if it's win function
    if (gameBuVa[0].str == gameBuVa[4].str &&
        gameBuVa[0].str == gameBuVa[8].str &&
        gameBuVa[0].str == piece) {
      if (gameBuVa[0].str != "") {
        lway = 7;
        return true;
      }
    }
    if (gameBuVa[6].str == gameBuVa[4].str &&
        gameBuVa[6].str == gameBuVa[2].str &&
        gameBuVa[6].str == piece) {
      if (gameBuVa[6].str != "") {
        lway = 8;
        return true;
      }
    }
    for (var i = 0; i <= 6; i += 3) {
      if (gameBuVa[i].str == gameBuVa[i + 1].str &&
          gameBuVa[i].str == gameBuVa[i + 2].str &&
          gameBuVa[i].str == piece) {
        if (gameBuVa[i].str != "") {
          // 0 => 1 - 3 => 2 - 6 => 3
          var type = {0: 1, 3: 2, 6: 3};
          lway = type[i];
          return true;
        }
      }
    }
    for (var i = 0; i <= 2; i++) {
      if (gameBuVa[i].str == gameBuVa[i + 3].str &&
          gameBuVa[i].str == gameBuVa[i + 6].str &&
          gameBuVa[i].str == piece) {
        if (gameBuVa[i].str != "") {
          lway = i + 4;
          return true;
        }
      }
    }
    return false;
  }

  void lposition() {
    // line x, y position FUNCTION
    double dinv = width * -1;

    for (var i = 0; i <= 3; i++) {
      if (lway == i) {
        lpos[0] = (width / 3) - 58;
        lpos[1] = dinv + 8 + ((i - 1) * (width / 3));
        lpos[2] = width - 58;
        lpos[3] = dinv + 8 + ((i - 1) * (width / 3));
      }
    } //  horizontal lines
    for (var i = 1; i <= 3; i++) {
      var nwidth = width - 10;
      if (lway == i + 3) {
        lpos[0] = i * (nwidth / 3) - 53;
        lpos[1] = dinv + 12;
        lpos[2] = i * (nwidth / 3) - 53;
        lpos[3] = dinv + 12 + ((width / 3) * 2);
      }
    } //  vertical lines
    if (lway == 7) {
      lpos[0] = (width / 3) - 58;
      lpos[1] = dinv + 12;
      lpos[2] = width - 62;
      lpos[3] = dinv + 12 + ((width / 3) * 2);
    } else if (lway == 8) {
      lpos[0] = width - 62;
      lpos[1] = dinv + 12;
      lpos[2] = (width / 3) - 58;
      lpos[3] = dinv + 12 + ((width / 3) * 2);
    }
    if (lway == 0) {
      lpos[0] = null;
      lpos[1] = null;
      lpos[2] = null;
      lpos[3] = null;
    }
  }

  int botsama() {
    // BOT MOVE FUNCTION
    Random rnd = new Random();
    for (var i = 0; i <= 8; i++) {
      if (gameBuVa[i].str == "") {
        gameBuVa[i].str = player2p;

        if (checker("$player2p")) {
          gameBuVa[i].str = "";
          return i;
        } else {
          gameBuVa[i].str = "";
        }
      }
    }
    for (var i = 0; i <= 8; i++) {
      if (gameBuVa[i].str == "") {
        gameBuVa[i].str = "$player1p";

        if (checker("$player1p")) {
          gameBuVa[i].str = "";
          return i;
        } else {
          gameBuVa[i].str = "";
        }
      }
    }
    if (gameBuVa[4].str == "") {
      return 4;
    }

    for (var i = 0; i < evoMatrix.length; i++) {
      if (evoMatrix[i][evoMatrix[i].length - 1] == -1) {
        print("checker: ${evoMatrix[evoMatrix.length - 1].length}");
        for (var j = 0; j <= evoMatrix[evoMatrix.length - 1].length - 1; j++) {
          print("info: ${moves[evoMatrix[evoMatrix.length - 1][j]]}");
          print("info 2: ${moves[evoMatrix[i][j]]}");
          if (moves[evoMatrix[evoMatrix.length - 1][j]] ==
              moves[evoMatrix[i][j]]) {
            print("J is $j");
            if (j >= 2) {
              print(
                  "hello ${evoMatrix[i][j]} --- ${evoMatrix[i][j + 1]} ---movestat = ${movestat(evoMatrix[i][j], evoMatrix[i][j + 1])}");
              wrongmove.add(movestat(evoMatrix[i][j], evoMatrix[i][j + 1]));
            }
          } else {
            break;
          }
        }
      }
    }
    print(evoMatrix);
    print("Wrong move :$wrongmove");
    if (wrongmove.length > 0) {
      for (var i = 0; i <= 8; i++) {
        bool pass = true;
        for (var j = 0; j < wrongmove.length; j++) {
          if (movestat(
                  evoMatrix[evoMatrix.length - 1]
                      [evoMatrix[evoMatrix.length - 1].length - 1],
                  i) ==
              wrongmove[j]) {
            pass = false;
            break;
          }
        }
        if (pass) {
          correctmove.add(i);
        }
      }
    }
    print("Correct move :$correctmove");
    print("--------------------");
    if (correctmove.length > 0) {
      for (var i = 0; i < correctmove.length; i++) {
        int min = 0, max = correctmove.length - 1;
        int range = min + rnd.nextInt(max - min);
        if (gameBuVa[range].str == "") {
          correctmove.removeRange(0, correctmove.length - 1);
          return range;
        } else {
          correctmove.removeAt(range);
        }
      }
    }
    for (var i = 0; i < 16; i++) {
      int min = 0, max = 7;
      int range = min + rnd.nextInt(max - min);
      if (gameBuVa[range].str == "" && moves[range] == 0) {
        return range;
      }
    }
    for (var i = 0; i < 16; i++) {
      int min = 0, max = 8;
      int range = min + rnd.nextInt(max - min);
      if (gameBuVa[range].str == "") {
        return range;
      }
    }
    return null;
  }

  int movestat(int pnum, int cnum) {
    if (cnum == 4) {
      return 0;
    } else {
      if (pnum == 0 || pnum == 8) {
        if (pnum == cnum) {
          return 1;
        } else if (cnum == 2 || cnum == 6) {
          return 2;
        } else if (pnum < cnum) {
          if (cnum == 1 || cnum == 3) {
            return 3;
          } else {
            return 4;
          }
        } else {
          if (cnum == 5 || cnum == 7) {
            return 3;
          } else {
            return 4;
          }
        }
      } else if (pnum == 2 || pnum == 6) {
        if (pnum == cnum) {
          return 1;
        } else if (cnum == 2 || cnum == 6) {
          return 2;
        } else if (pnum < 4) {
          if (cnum == 1 || cnum == 5) {
            return 3;
          } else {
            return 4;
          }
        } else {
          if (cnum == 3 || cnum == 7) {
            return 3;
          } else {
            return 4;
          }
        }
      }
    }

    return null;
  }

  void gamemode(int index) {
    // GAME MODE FUNCTION
    if (tnumb == 9 || checker("O") || checker("X")) {
      if (restartgp == 2) {
        minirestart();
      } else {
        restartgp++;
        statinfo = "TAP ONE MORE TIME TO RESTART";
      }
    } else {
      if (solo) {
        if (gameBuVa[index].str == "") {
          gameBuVa[index].str = "$player1p";
          tnumb++;

          evoMatrix[ngame].add(index);

          var botchoose = botsama();
          if (tnumb != 9 && !checker("$player1p")) {
            gameBuVa[botchoose].str = "$player2p";
            tnumb++;
          }

          evoMatrix[ngame].add(botchoose);
        }
      } else {
        if (turn == 1 && gameBuVa[index].str == "") {
          gameBuVa[index].str = "$player1p";
          tnumb++;
          turn = 2;
          statinfo = "P2($player2p) TURN";
        } else if (turn == 2 && gameBuVa[index].str == "") {
          gameBuVa[index].str = "$player2p";
          tnumb++;
          turn = 1;
          statinfo = "P1($player1p) TURN";
        }
        evoMatrix[ngame].add(index);
      }

      if (checker("$player1p")) {
        pwins[0] += 1;
        if (solo) {
          showR("P1[🏆 WINNER]: ${pwins[0]} WINS / Bot: ${pwins[1]} WINS");
        } else {
          showR("P1[🏆 WINNER]: ${pwins[0]} WINS / P2: ${pwins[1]} WINS");
        }
        evoMatrix[ngame].add(-1);
      }
      if (checker("$player2p")) {
        pwins[1] += 1;
        if (solo) {
          showR("P1: ${pwins[0]} WINS / Bot[🏆 WINNER]: ${pwins[1]} WINS");
        } else {
          showR("P1: ${pwins[0]} WINS / P2[🏆 WINNER]: ${pwins[1]} WINS");
        }
      }
      if (tnumb == 9 && !checker("O") && !checker("X")) {
        lway = 0;
        vxo = false;
        statinfob = false;
        vpainter = false;
        dialog = true;
        showR("TIE");
        evoMatrix[ngame].add(10);
      }
      print(evoMatrix);
    }
  }

  void showR(String stat) {
    // SHOW LINE IN THE RESULT FUNCTION
    lposition();
    painter.paintL(painter, lpos[0], lpos[1], lpos[2], lpos[3]);

    statinfo = stat;
  }

  void minirestart() {
    painter.paintL(painter, null, null, null, null);
    vxo = true;
    dialog = false;
    statinfob = true;
    vpainter = true;

    tnumb = 0;
    turn = 1;
    restartgp = 1;
    if (evoMatrix[ngame].length != 0) {
      evoMatrix.add(new List());
      ngame++;
    }

    if (solo) {
      statinfo = "P1: ${pwins[0]} WINS / Bot: ${pwins[1]} WINS";
    } else {
      statinfo = "P1: ${pwins[0]} WINS / P2: ${pwins[1]} WINS";
    }

    lway = 0;
    for (var i = 0; i < 9; i++) {
      gameBuVa[i].str = "";
    }
  }

  void restart() {
    // RESTART ALL DATA
    painter.paintL(painter, null, null, null, null);
    for (var i = 0; i < 9; i++) {
      gameBuVa[i].str = "";
    }
    tnumb = 0;
    turn = 1;
    restartgp = 1;

    pwins[0] = 0;
    pwins[1] = 0;

    if (evoMatrix[ngame].length != 0) {
      evoMatrix.add(new List());
      ngame++;
    }

    statinfo = "";
    lway = 0;

    dialog = false;
    vxo = false;
    statinfob = false;
    vpainter = false;
    vcheckbox = true;
    print(evoMatrix);
  }
}

class GameButtonValue {
  String str = "";
  GameButtonValue(String value) {
    this.str = value;
  }
}

class PainterLines extends CustomPainter {
  double sx;
  double sy;
  double ex;
  double ey;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    if (sx != null && sy != null && ex != null && ey != null) {
      Offset startingPoint = Offset(sx, sy);
      Offset endingPoint = Offset(ex, ey);

      canvas.drawLine(startingPoint, endingPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return null;
  }

  paintL(CustomPainter painter, double sx, double sy, double ex, double ey) {
    this.sx = sx;
    this.sy = sy;
    this.ex = ex;
    this.ey = ey;
    shouldRepaint(painter);
  }
}
