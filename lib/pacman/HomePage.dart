import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:workapp/pacman/ghost.dart';
import 'package:workapp/pacman/ghost3.dart';
import 'package:workapp/pacman/ghost2.dart';
import 'package:workapp/pacman/path.dart';
import 'package:workapp/pacman/pixel.dart';
import 'package:workapp/pacman/player.dart';

import 'maps.dart';

class PHomePage extends StatefulWidget {
  @override
  _PHomePageState createState() => _PHomePageState();
}

enum GhostState { inCage, leaving, active , chasing, scatter, frightened,home}




class _PHomePageState extends State<PHomePage> {

  GhostState ghostState = GhostState.inCage;
  GhostState ghostState2 = GhostState.inCage;
  GhostState ghostState3 = GhostState.inCage;
  GhostState ghostState4 = GhostState.inCage;
  int leavingStepsRemaining = 3;
  Timer? cageTimer1;
  Timer? cageTimer2;
  Timer? cageTimer3;
  Timer? cageTimer4;
  static int numberInPlayerRow = 28;
  int numberOfPlayerSquares = numberInPlayerRow*31;
  int numberOfSquares = (numberInPlayerRow * 31);
  int player = 656;
  // int ghost = 407;
  int ghost1 = 29;
  int ghost1HomeLocation = 838;
  int ghost2 = 406;
  int ghost3 = 405;
  bool preGame = true;
  bool mouthClosed = false;
  var controller;
  int score = 0;
  bool paused = false;

  Timer? _timer;
  List<int> food = [];
  List<int> pebbles = [];
  String direction = "right";
  String ghostLast = "left";
  String ghostLast2 = "left";
  String ghostLast3 = "down";

  void start1GhostCageTimer() {
    cageTimer1?.cancel();
    cageTimer1 = Timer(const Duration(seconds: 15), () {
      setState(() {
        ghostState = GhostState.active;
        ghostLast = "up";
        leavingStepsRemaining = 3;
      });
    });
  }

  void start2GhostCageTimer() {
    cageTimer2?.cancel();
    cageTimer2 = Timer(const Duration(seconds: 25), () {
      setState(() {
        ghostState2 = GhostState.leaving;
        ghostLast = "up";
        leavingStepsRemaining = 3;
      });
    });
  }
  void start3GhostCageTimer() {
    cageTimer3?.cancel();
    cageTimer3 = Timer(const Duration(seconds: 40), () {
      setState(() {
        ghostState3 = GhostState.leaving;
        ghostLast = "up";
        leavingStepsRemaining = 3;
      });
    });
  }
  void start4GhostCageTimer() {
    cageTimer4?.cancel();
    cageTimer4 = Timer(const Duration(seconds: 60), () {
      setState(() {
        ghostState4 = GhostState.leaving;
        ghostLast = "up";
        leavingStepsRemaining = 3;
      });
    });
  }
  void startGame() {
    _focusNode.requestFocus();
    resumeGame();
    start1GhostCageTimer();
    // start2GhostCageTimer();
    // start3GhostCageTimer();
    if (preGame) {
      preGame = false;
      getFood();
    }
  }

  void pauseGame() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
      print('Timer stopped manually');
    }
  }

  void resumeGame() {
    _timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });
      playerMovement();
      if (food.contains(player)) {
        setState(() {
          food.remove(player);
        });
        score++;
      }
      if (pebbles.contains(player)) {
        setState(() {
          pebbles.remove(player);
        });
        score+= 20;
      }
      if (player == ghost1 || player == ghost2 || player == ghost3) {
        setState(() {
          player = -1;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text("Game Over!")),
                content: Text("Your Score : " + (score).toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        player = numberInPlayerRow * 14 + 1;
                        ghost1 = numberInPlayerRow * 2 - 2;
                        ghost2 = numberInPlayerRow * 9 - 1;
                        ghost3 = numberInPlayerRow * 11 - 2;
                        preGame = false;
                        mouthClosed = false;
                        direction = "right";
                        food.clear();
                        pebbles.clear();
                        getFood();
                        score = 0;
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Restart'),
                    ),
                  )
                ],
              );
            });
      }
      moveGhost();
      moveGhost2();
      moveGhost3();
    });
  }

  void restart() {
    player = 656;
    ghost1 = 407;
    ghost2 = 406;
    ghost3 = 405;
    score = 0;
    startGame();
  }

  void getFood() {
    food.clear();
    pebbles.clear();

    for (int i = 0; i < numberOfPlayerSquares; i++) {
      if (barriers.contains(i) || blankSpaces.contains(i)) continue;

      if (pebbleLocation.contains(i)) {
        pebbles.add(i);
      } else {
        food.add(i);
      }
    }
  }

  void playerMovement() {
    if (direction == "left") {
      if(!leftSideBoarder.contains(player)){
      if (!barriers.contains(player - 1)) {
        setState(() {
          player--;
        });
      }
      }
      else{
        setState(() {
          player += 27;
        });
      }
    } else if (direction == "right") {
      if(!rightSideBoarder.contains(player)){
      if (!barriers.contains(player + 1)) {
        setState(() {
          player++;
        });
      }}
      else{
        player -= 27;
      }
    } else if (direction == "up") {
      if(!topBoarder.contains(player)){
      if (!barriers.contains(player - numberInPlayerRow)) {
        setState(() {
          player -= numberInPlayerRow;
        });
      }
      }
      else{
        player += 840;
      }
    } else if (direction == "down") {
      if(!bottomBoarder.contains(player)) {
        if (!barriers.contains(player + numberInPlayerRow)) {
          setState(() {
            player += numberInPlayerRow;
          });
        }
      }
      else{
        player -= 840;
      }
    }

    }

    void ghost1AI(){
    if(ghost1HomeLocation > ghost1){
      if(!barriers.contains(ghost1 + numberOfPlayerSquares)&& ghostLast != "stuck"){
        setState(() {
          ghost1 += numberOfPlayerSquares;
          ghostLast = "down";
        });
      }
      else if(!barriers.contains(ghost1 + 1)&& ghostLast != "stuck"){
        setState(() {
          ghost1 ++;
          ghostLast = "right";
        });
      }
      else if(barriers.contains(ghost1 + 1)&& barriers.contains(ghost1 + numberOfPlayerSquares)){
        ghostLast="stuck";
      }
      else if(!barriers.contains(ghost1 -1)&&ghostLast == "stuck" && barriers.contains(ghost1 + numberOfPlayerSquares)){
        ghost1 --;
      }
      else if(!barriers.contains(ghost1 + numberOfPlayerSquares)){
        ghostLast = "down";
        ghost1 += numberOfPlayerSquares;
      }
      else if(ghost1 == ghost1HomeLocation){
        ghostState = GhostState.home;
      }
    }

    }

  void oldMoveGhost() {
      switch (ghostLast) {
        case "left":
          if (!barriers.contains(ghost1 - 1)) {
            setState(() {
              ghost1--;
            });
          }
          else {
            if (!barriers.contains(ghost1 + numberInPlayerRow)) {
              setState(() {
                ghost1 += numberInPlayerRow;
                ghostLast = "down";
              });
            }
            else if (!barriers.contains(ghost1 + 1)) {
              setState(() {
                ghost1++;
                ghostLast = "right";
              });
            }
            else if (!barriers.contains(ghost1 - numberInPlayerRow)) {
              setState(() {
                ghost1 -= numberInPlayerRow;
                ghostLast = "up";
              });
            }
          }
          break;
        case "right":
          if (!barriers.contains(ghost1 + 1)) {
            setState(() {
              ghost1++;
            });
          } else {
            if (!barriers.contains(ghost1 - numberInPlayerRow)) {
              setState(() {
                ghost1 -= numberInPlayerRow;
                ghostLast = "up";
              });
            } else if (!barriers.contains(ghost1 + numberInPlayerRow)) {
              setState(() {
                ghost1 += numberInPlayerRow;
                ghostLast = "down";
              });
            } else if (!barriers.contains(ghost1 - 1)) {
              setState(() {
                ghost1--;
                ghostLast = "left";
              });
            }
          }
          break;
        case "up":
          if (!barriers.contains(ghost1 - numberInPlayerRow)) {
            setState(() {
              ghost1 -= numberInPlayerRow;
              ghostLast = "up";
            });
          } else {
            if (!barriers.contains(ghost1 + 1)) {
              setState(() {
                ghost1++;
                ghostLast = "right";
              });
            } else if (!barriers.contains(ghost1 - 1)) {
              setState(() {
                ghost1--;
                ghostLast = "left";
              });
            } else if (!barriers.contains(ghost1 + numberInPlayerRow)) {
              setState(() {
                ghost1 += numberInPlayerRow;
                ghostLast = "down";
              });
            }
          }
          break;
        case "down":
          if (!barriers.contains(ghost1 + numberInPlayerRow)) {
            setState(() {
              ghost1 += numberInPlayerRow;
              ghostLast = "down";
            });
          } else {
            if (!barriers.contains(ghost1 - 1)) {
              setState(() {
                ghost1--;
                ghostLast = "left";
              });
            } else if (!barriers.contains(ghost1 + 1)) {
              setState(() {
                ghost1++;
                ghostLast = "right";
              });
            } else if (!barriers.contains(ghost1 - numberInPlayerRow)) {
              setState(() {
                ghost1 -= numberInPlayerRow;
                ghostLast = "up";
              });
            }
          }
          break;
      }

  }

  void oldMoveGhost2() {
    switch (ghostLast2) {
      case "left":
        if (!barriers.contains(ghost2 - 1)) {
          setState(() {
            ghost2--;
          });
        } else {
          if (!barriers.contains(ghost2 + numberInPlayerRow)) {
            setState(() {
              ghost2 += numberInPlayerRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInPlayerRow)) {
            setState(() {
              ghost2 -= numberInPlayerRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost2 + 1)) {
          setState(() {
            ghost2++;
          });
        } else {
          if (!barriers.contains(ghost2 - numberInPlayerRow)) {
            setState(() {
              ghost2 -= numberInPlayerRow;
              ghostLast2 = "up";
            });
          } else if (!barriers.contains(ghost2 + numberInPlayerRow)) {
            setState(() {
              ghost2 += numberInPlayerRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost2 - numberInPlayerRow)) {
          setState(() {
            ghost2 -= numberInPlayerRow;
            ghostLast2 = "up";
          });
        } else {
          if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + numberInPlayerRow)) {
            setState(() {
              ghost2 += numberInPlayerRow;
              ghostLast2 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost2 + numberInPlayerRow)) {
          setState(() {
            ghost2 += numberInPlayerRow;
            ghostLast2 = "down";
          });
        } else {
          if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInPlayerRow)) {
            setState(() {
              ghost2 -= numberInPlayerRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
    }
  }

  void oldMoveGhost3() {
    switch (ghostLast) {
      case "left":
        if (!barriers.contains(ghost3 - 1)) {
          setState(() {
            ghost3--;
          });
        } else {
          if (!barriers.contains(ghost3 + numberInPlayerRow)) {
            setState(() {
              ghost3 += numberInPlayerRow;
              ghostLast3 = "down";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInPlayerRow)) {
            setState(() {
              ghost3 -= numberInPlayerRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost3 + 1)) {
          setState(() {
            ghost3++;
          });
        } else {
          if (!barriers.contains(ghost3 - numberInPlayerRow)) {
            setState(() {
              ghost3 -= numberInPlayerRow;
              ghostLast3 = "up";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInPlayerRow)) {
            setState(() {
              ghost3 += numberInPlayerRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost3 - numberInPlayerRow)) {
          setState(() {
            ghost3 -= numberInPlayerRow;
            ghostLast3 = "up";
          });
        } else {
          if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInPlayerRow)) {
            setState(() {
              ghost3 += numberInPlayerRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost3 + numberInPlayerRow)) {
          setState(() {
            ghost3 += numberInPlayerRow;
            ghostLast3 = "down";
          });
        } else {
          if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInPlayerRow)) {
            setState(() {
              ghost3 -= numberInPlayerRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost() {
    switch (ghostState) {


      case GhostState.inCage:
        switch (ghostLast){
          case "left":
            if (!barriers.contains(ghost1 - 1)) {
              setState(() {
                ghost1--;
              });
            }
            else if (!barriers.contains(ghost1 + 1)) {
              setState(() {
                ghost1++;
                ghostLast = "right";
              });
            }
          case"right":
            if (!barriers.contains(ghost1 + 1)) {
              setState(() {
                ghost1++;
              });
            }
            else if (!barriers.contains(ghost1 - 1)) {
              setState(() {
                ghost1--;
                ghostLast = "left";
              });
            }
        }
        return;

      case GhostState.leaving:
        if (leavingStepsRemaining > 0) {
          setState(() {
            ghost1 -= numberInPlayerRow;
            leavingStepsRemaining--;
          });
        } else {
          ghostState = GhostState.active;
          leavingStepsRemaining =3;
        }
        return;

      case GhostState.active:
        break;
      case GhostState.chasing:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.scatter:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.frightened:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.home:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    oldMoveGhost();
  }

  void moveGhost2() {
    switch (ghostState2) {


      case GhostState.inCage:
        switch (ghostLast2){
          case "left":
            if (!barriers.contains(ghost2 - 1)) {
              setState(() {
                ghost2--;
              });
            }
            else if (!barriers.contains(ghost2 + 1)) {
              setState(() {
                ghost2++;
                ghostLast2 = "right";
              });
            }
          case"right":
            if (!barriers.contains(ghost2 + 1)) {
              setState(() {
                ghost2++;
              });
            }
            else if (!barriers.contains(ghost2 - 1)) {
              setState(() {
                ghost2--;
                ghostLast2 = "left";
              });
            }
        }
        return;


      case GhostState.leaving:
        if (leavingStepsRemaining > 0) {
          setState(() {
            ghost2 -= numberInPlayerRow;
            leavingStepsRemaining--;
          });
        } else {
          ghostState2 = GhostState.active;
          leavingStepsRemaining =3;
        }
        return;


      case GhostState.active:
        break;
      case GhostState.chasing:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.scatter:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.frightened:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.home:
        // TODO: Handle this case.
        throw UnimplementedError();
    }


    oldMoveGhost2();
  }

  void moveGhost3() {
    switch (ghostState3) {


      case GhostState.inCage:
        switch (ghostLast3){
          case "left":
            if (!barriers.contains(ghost3 - 1)) {
              setState(() {
                ghost3--;
              });
            }
            else if (!barriers.contains(ghost3 + 1)) {
              setState(() {
                ghost3++;
                ghostLast3 = "right";
              });
            }
          case"right":
            if (!barriers.contains(ghost3 + 1)) {
              setState(() {
                ghost3++;
              });
            }
            else if (!barriers.contains(ghost3 - 1)) {
              setState(() {
                ghost3--;
                ghostLast3 = "left";
              });
            }
        }
        return;


      case GhostState.leaving:
        if (leavingStepsRemaining > 0) {
          setState(() {
            ghost3 -= numberInPlayerRow;
            leavingStepsRemaining--;
          });
        } else {
          ghostState3 = GhostState.active;
          leavingStepsRemaining =3;
        }
        return;


      case GhostState.active:
        break;
      case GhostState.chasing:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.scatter:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.frightened:
        // TODO: Handle this case.
        throw UnimplementedError();
      case GhostState.home:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    oldMoveGhost3();
  }



  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: (MediaQuery.of(context).size.height.toInt() * 0.0139).toInt(),
            child: Focus(
              autofocus: false,
              focusNode: _focusNode,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
                      event.logicalKey == LogicalKeyboardKey.keyD) {
                    setState(() => direction = "right");
                    return KeyEventResult.handled;
                  }
                  if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
                      event.logicalKey == LogicalKeyboardKey.keyA) {
                    setState(() => direction = "left");
                    return KeyEventResult.handled;
                  }
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                      event.logicalKey == LogicalKeyboardKey.keyW) {
                    setState(() => direction = "up");
                    return KeyEventResult.handled;
                  }
                  if (event.logicalKey == LogicalKeyboardKey.keyS) {
                    setState(() => direction = "down");
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: Stack(
                children: [
                  GridView.builder(
                    padding: (MediaQuery.of(context).size.height.toInt() * 0.0139)
                        .toInt() >
                        10
                        ? EdgeInsets.only(top: 80)
                        : EdgeInsets.only(top: 20),
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfPlayerSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberInPlayerRow),
                    itemBuilder: (BuildContext context, int index) {
                      if (mouthClosed && player == index) {
                        return Padding(
                          padding: EdgeInsets.all(1),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow, shape: BoxShape.circle),
                          ),
                        );
                      } else if (player == index) {
                        switch (direction) {
                          case "left":
                            return Transform.rotate(
                              angle: pi,
                              child: MyPlayer(),
                            );
                          case "right":
                            return MyPlayer();
                          case "up":
                            return Transform.rotate(
                              angle: 3 * pi / 2,
                              child: MyPlayer(),
                            );
                          case "down":
                            return Transform.rotate(
                              angle: pi / 2,
                              child: MyPlayer(),
                            );
                          default:
                            return MyPlayer();
                        }
                      } else if (ghost1 == index) {
                        return MyGhost();
                      }
                      else if (ghost2 == index) {
                        return MyGhost2();
                      }
                      else if (ghost3 == index) {
                        return MyGhost3();
                      }
                      else if (barriers.contains(index)) {
                        return MyPixel(
                          innerColor: Colors.blue[900],
                          outerColor: Colors.blue[800],
                          child: Text("$index"),
                          // child: Text(index.toString()),
                        );
                      }
                      else if(blankSpaces.contains(index)){
                        return MyPath(
                          size: 6,
                          innerColor: Colors.white,
                          outerColor: Colors.black,
                          child: Text("$index"),
                        );
                      }
                      else if (pebbles.contains(index)) {
                        return MyPath(
                          size: 0,
                          innerColor: Colors.yellow,
                          outerColor: Colors.black,
                        );
                      }
                      else if (food.contains(index)) {
                        return MyPath(
                          size: 3,
                          innerColor: Colors.yellow,
                          outerColor: Colors.black,
                        );
                      }
                      else {
                        return MyPath(
                          size: 6,
                          innerColor: Colors.white,
                          outerColor: Colors.black,
                          child: Text("$index"),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    " Score : " + (score).toString(),
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                  preGame?
                  TextButton(onPressed: () {
                    startGame();
                  }, child: Text("P L A Y",
                      style: TextStyle(color: Colors.white, fontSize: 23)),
                  ):Container(),
                  IconButton(
                      onPressed: () {
                        if (!paused) {
                          pauseGame();
                          paused = true;
                        } else {
                          resumeGame();
                          paused = false;
                        }
                      },
                      icon: (paused)
                          ? Icon(
                              Icons.pause,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
