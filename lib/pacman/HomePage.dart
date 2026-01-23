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

enum GhostState { inCage, leaving, active , scatter, frightened,home}




class _PHomePageState extends State<PHomePage> {

  GhostState ghostState = GhostState.inCage;
  GhostState ghostState2 = GhostState.inCage;
  GhostState ghostState3 = GhostState.inCage;
  GhostState ghostState4 = GhostState.inCage;
  int ghost1LeavingSteps = 3;
  int ghost2LeavingSteps = 3;
  int ghost3LeavingSteps = 3;
  int ghost4LeavingSteps = 3;
  Timer? cageTimer1;
  Timer? cageTimer2;
  Timer? cageTimer3;
  Timer? cageTimer4;
  Timer? niceTimer1;
  Timer? niceTimer2;
  Timer? niceTimer3;
  Timer? niceTimer4;
  static int numberInRow = 28;
  int playerLives = 3;
  int numberOfSquares = (numberInRow * 31);
  int player = 656;
  int cageLocation = 405;
  int playerStartLocation = 656;
  int ghost1 = 407;
  int ghost2 = 406;
  int ghost3 = 405;
  int ghost4 = 406;
  int ghost1HomeLocation = 54;
  int ghost2HomeLocation =29;
  int ghost3HomeLocation =838;
  int ghost4HomeLocation =813;


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
  String ghostLast4 = "up";


  int wrapIndex(int index) {
    if (rightSideBoarder.contains(index)) {
      return index - (numberInRow - 1);
    }
    if (leftSideBoarder.contains(index)) {
      return index + (numberInRow - 1);
    }
    if (topBoarder.contains(index)) {
      return index + numberOfSquares - numberInRow;
    }
    if (bottomBoarder.contains(index)) {
      return index - numberOfSquares + numberInRow;
    }
    return index;
  }

  bool canMoveLeft(int i) => i % numberInRow != 0 && !barriers.contains(i-1);
  bool canMoveRight(int i) => (i+1) % numberInRow != 0 && !barriers.contains(i+1);
  bool canMoveUp(int i) => i - numberInRow >= 0 && !barriers.contains(i-numberInRow);
  bool canMoveDown(int i) => i + numberInRow < numberOfSquares && !barriers.contains(i+numberInRow);

  String opposite(String dir){
    switch(dir){
      case "left": return "right";
      break;
      case "right": return "left";
      break;
      case "up": return "down";
      break;
      case "down": return "up";
      break;
    }
    return "";
  }

  Point<int> toPoint(int index) =>
      Point(index ~/ numberInRow, index % numberInRow);

  int distance(int fromIndex, int targetIndex){
    final a = toPoint(fromIndex);
    final b = toPoint(targetIndex);
    return (a.x - b.x) * (a.x -b.x) + (a.y-b.y)*(a.y-b.y);
  }
  String chooseDirection(int ghostIndex,int targetIndex,List<String> validDirs){
    String bestDir = validDirs.first;
    int bestDist = 999999;
    for (var dir in validDirs){
      int nextIndex;
      switch (dir){
        case "left":
          nextIndex = ghostIndex - 1;
          break;
        case "right":
          nextIndex = ghostIndex + 1;
          break;
        case "up":
          nextIndex = ghostIndex - numberInRow;
          break;
        case "down":
          nextIndex = ghostIndex + numberInRow;
          break;
        default:
          continue;
      }
      int d = distance(nextIndex,targetIndex);
      if(d < bestDist){
        bestDist = d;
        bestDir = dir;
      }
    }
    return bestDir;
  }



  void start1GhostCageTimer() {
    cageTimer1?.cancel();
    cageTimer1 = Timer(const Duration(seconds: 15), () {
      setState(() {
        ghostState = GhostState.leaving;
        ghostLast = canMoveLeft(ghost1) ? "left" : "right";
        ghost1LeavingSteps = 3;
      });
    });
  }

  void startNiceGhostTimer(){

  }

  void start2GhostCageTimer() {
    cageTimer2?.cancel();
    cageTimer2 = Timer(const Duration(seconds: 25), () {
      setState(() {
        ghostState2 = GhostState.leaving;
        ghostLast2 = canMoveLeft(ghost2) ? "left" : "right";
        ghost2LeavingSteps = 3;
      });
    });
  }
  void start3GhostCageTimer() {
    cageTimer3?.cancel();
    cageTimer3 = Timer(const Duration(seconds: 40), () {
      setState(() {
        ghostState3 = GhostState.leaving;
        ghostLast3 = canMoveLeft(ghost3) ? "left" : "right";
        ghost1LeavingSteps = 3;
      });
    });
  }
  void start4GhostCageTimer() {
    cageTimer4?.cancel();
    cageTimer4 = Timer(const Duration(seconds: 60), () {
      setState(() {
        ghostState4 = GhostState.leaving;
        // ghostLast4 = canMoveLeft(ghost4) ? "left" : "right";
        // ghost4LeavingSteps = 3;
      });
    });
  }
  void startGame() {
    _focusNode.requestFocus();
    resumeGame();
    start1GhostCageTimer();
    start2GhostCageTimer();
    start3GhostCageTimer();
    // start4GhostCageTimer();
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
        if(playerLives == 0) {
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
                          hardRestart();
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
        else{
          playerLives--;
          softRestart();
        }
      }
      moveGhost();
      moveGhost2();
      moveGhost3();
    });
  }

  softRestart(){
    player = playerStartLocation;
    ghost1 = cageLocation;
    ghost2 = cageLocation;
    ghost3 = cageLocation;
    ghostState = GhostState.inCage;
    ghostState2 = GhostState.inCage;
    ghostState3 = GhostState.inCage;
    ghost1LeavingSteps=3;
    ghost2LeavingSteps = 3;
    ghost3LeavingSteps=3;
    pauseGame();
    resumeGame();
    start1GhostCageTimer();
    start2GhostCageTimer();
    start3GhostCageTimer();
    mouthClosed = false;
    direction = "right";

  }


  hardRestart(){
    player = playerStartLocation;
    ghost1 = cageLocation;
    ghost2 = cageLocation;
    ghost3 = cageLocation;
    ghostState = GhostState.inCage;
    ghostState2 = GhostState.inCage;
    ghostState3 = GhostState.inCage;
    ghost1LeavingSteps=3;
    ghost2LeavingSteps = 3;
    ghost3LeavingSteps=3;
    score = 0;
    playerLives = 3;
    preGame = true;
    food.clear();
    pebbles.clear();
    getFood();
    pauseGame();
    resumeGame();
    start1GhostCageTimer();
    start2GhostCageTimer();
    start3GhostCageTimer();
    mouthClosed = false;
    direction = "right";

  }

  void getFood() {
    food.clear();
    pebbles.clear();

    for (int i = 0; i < numberOfSquares; i++) {
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
      if (!barriers.contains(player - numberInRow)) {
        setState(() {
          player -= numberInRow;
        });
      }
      }
      else{
        player += 840;
      }
    } else if (direction == "down") {
      if(!bottomBoarder.contains(player)) {
        if (!barriers.contains(player + numberInRow)) {
          setState(() {
            player += numberInRow;
          });
        }
      }
      else{
        player -= 840;
      }
    }

    }
    int movement(int character,String direction){
    int changedCharacter = 0;
    switch(direction){
      case "right":
        changedCharacter = character +1;
        return changedCharacter;
        break;
      case "left":
        changedCharacter = character -1;
        return changedCharacter;
        break;
      case "up":
        changedCharacter = character - numberInRow;
        return changedCharacter;
        break;
      case"down":
        changedCharacter = character + numberInRow;
        return changedCharacter;
        break;
        default:
          return character;
          break;
    }
    }



  void ghost1AI(int target) {
    List<String> possibleDirs = [];

    if (canMoveLeft(ghost1)) possibleDirs.add("left");
    if (canMoveRight(ghost1)) possibleDirs.add("right");
    if (canMoveUp(ghost1)) possibleDirs.add("up");
    if (canMoveDown(ghost1)) possibleDirs.add("down");

    if (possibleDirs.length > 2) {
      possibleDirs.remove(opposite(ghostLast));
      if (possibleDirs.isEmpty) {
        possibleDirs.add(opposite(ghostLast));
      }
      ghostLast = chooseDirection(ghost1, target, possibleDirs);
    }

    int nextPos = movement(ghost1, ghostLast);
    nextPos = wrapIndex(nextPos);

    if (barriers.contains(nextPos)) {
      possibleDirs.clear();
      if (canMoveLeft(ghost1)) possibleDirs.add("left");
      if (canMoveRight(ghost1)) possibleDirs.add("right");
      if (canMoveUp(ghost1)) possibleDirs.add("up");
      if (canMoveDown(ghost1)) possibleDirs.add("down");

      possibleDirs.remove(opposite(ghostLast));

      if (possibleDirs.isNotEmpty) {
        ghostLast = chooseDirection(ghost1, target, possibleDirs);
        nextPos = wrapIndex(movement(ghost1, ghostLast));
      }
    }

    setState(() {
      ghost1 = nextPos;
    });
  }
  void ghost2AI(int target) {
    List<String> possibleDirs = [];

    if (canMoveLeft(ghost2)) possibleDirs.add("left");
    if (canMoveRight(ghost2)) possibleDirs.add("right");
    if (canMoveUp(ghost2)) possibleDirs.add("up");
    if (canMoveDown(ghost2)) possibleDirs.add("down");

    if (possibleDirs.length > 2) {
      possibleDirs.remove(opposite(ghostLast2));
      if (possibleDirs.isEmpty) {
        possibleDirs.add(opposite(ghostLast2));
      }
      ghostLast2 = chooseDirection(ghost2, target, possibleDirs);
    }

    int nextPos = movement(ghost2, ghostLast2);
    nextPos = wrapIndex(nextPos);

    if (barriers.contains(nextPos)) {
      possibleDirs.clear();
      if (canMoveLeft(ghost2)) possibleDirs.add("left");
      if (canMoveRight(ghost2)) possibleDirs.add("right");
      if (canMoveUp(ghost2)) possibleDirs.add("up");
      if (canMoveDown(ghost2)) possibleDirs.add("down");

      possibleDirs.remove(opposite(ghostLast2));

      if (possibleDirs.isNotEmpty) {
        ghostLast2 = chooseDirection(ghost2, target, possibleDirs);
        nextPos = wrapIndex(movement(ghost2, ghostLast2));
      }
    }

    setState(() {
      ghost2 = nextPos;
    });
  }
  void ghost3AI(int target) {
    List<String> possibleDirs = [];

    if (canMoveLeft(ghost3)) possibleDirs.add("left");
    if (canMoveRight(ghost3)) possibleDirs.add("right");
    if (canMoveUp(ghost3)) possibleDirs.add("up");
    if (canMoveDown(ghost3)) possibleDirs.add("down");

    if (possibleDirs.length > 2) {
      possibleDirs.remove(opposite(ghostLast3));
      if (possibleDirs.isEmpty) {
        possibleDirs.add(opposite(ghostLast3));
      }
      ghostLast3 = chooseDirection(ghost3, target, possibleDirs);
    }

    int nextPos = movement(ghost3, ghostLast3);
    nextPos = wrapIndex(nextPos);

    if (barriers.contains(nextPos)) {
      possibleDirs.clear();
      if (canMoveLeft(ghost3)) possibleDirs.add("left");
      if (canMoveRight(ghost3)) possibleDirs.add("right");
      if (canMoveUp(ghost3)) possibleDirs.add("up");
      if (canMoveDown(ghost3)) possibleDirs.add("down");

      possibleDirs.remove(opposite(ghostLast3));

      if (possibleDirs.isNotEmpty) {
        ghostLast3 = chooseDirection(ghost3, target, possibleDirs);
        nextPos = wrapIndex(movement(ghost3, ghostLast3));
      }
    }

    setState(() {
      ghost3 = nextPos;
    });
  }
  void ghost4AI(int target) {
    List<String> possibleDirs = [];

    if (canMoveLeft(ghost4)) possibleDirs.add("left");
    if (canMoveRight(ghost4)) possibleDirs.add("right");
    if (canMoveUp(ghost4)) possibleDirs.add("up");
    if (canMoveDown(ghost4)) possibleDirs.add("down");

    if (possibleDirs.length > 2) {
      possibleDirs.remove(opposite(ghostLast4));
      if (possibleDirs.isEmpty) {
        possibleDirs.add(opposite(ghostLast4));
      }
      ghostLast4 = chooseDirection(ghost4, target, possibleDirs);
    }

    int nextPos = movement(ghost4, ghostLast4);
    nextPos = wrapIndex(nextPos);

    if (barriers.contains(nextPos)) {
      possibleDirs.clear();
      if (canMoveLeft(ghost4)) possibleDirs.add("left");
      if (canMoveRight(ghost4)) possibleDirs.add("right");
      if (canMoveUp(ghost4)) possibleDirs.add("up");
      if (canMoveDown(ghost4)) possibleDirs.add("down");

      possibleDirs.remove(opposite(ghostLast4));

      if (possibleDirs.isNotEmpty) {
        ghostLast4 = chooseDirection(ghost4, target, possibleDirs);
        nextPos = wrapIndex(movement(ghost4, ghostLast4));
      }
    }

    setState(() {
      ghost4 = nextPos;
    });
  }


  // void oldMoveGhost2() {
  //   switch (ghostLast2) {
  //     case "left":
  //       if (!barriers.contains(ghost2 - 1)) {
  //         setState(() {
  //           ghost2--;
  //         });
  //       } else {
  //         if (!barriers.contains(ghost2 + numberInRow)) {
  //           setState(() {
  //             ghost2 += numberInRow;
  //             ghostLast2 = "down";
  //           });
  //         } else if (!barriers.contains(ghost2 + 1)) {
  //           setState(() {
  //             ghost2++;
  //             ghostLast2 = "right";
  //           });
  //         } else if (!barriers.contains(ghost2 - numberInRow)) {
  //           setState(() {
  //             ghost2 -= numberInRow;
  //             ghostLast2 = "up";
  //           });
  //         }
  //       }
  //       break;
  //     case "right":
  //       if (!barriers.contains(ghost2 + 1)) {
  //         setState(() {
  //           ghost2++;
  //         });
  //       } else {
  //         if (!barriers.contains(ghost2 - numberInRow)) {
  //           setState(() {
  //             ghost2 -= numberInRow;
  //             ghostLast2 = "up";
  //           });
  //         } else if (!barriers.contains(ghost2 + numberInRow)) {
  //           setState(() {
  //             ghost2 += numberInRow;
  //             ghostLast2 = "down";
  //           });
  //         } else if (!barriers.contains(ghost2 - 1)) {
  //           setState(() {
  //             ghost2--;
  //             ghostLast2 = "left";
  //           });
  //         }
  //       }
  //       break;
  //     case "up":
  //       if (!barriers.contains(ghost2 - numberInRow)) {
  //         setState(() {
  //           ghost2 -= numberInRow;
  //           ghostLast2 = "up";
  //         });
  //       } else {
  //         if (!barriers.contains(ghost2 + 1)) {
  //           setState(() {
  //             ghost2++;
  //             ghostLast2 = "right";
  //           });
  //         } else if (!barriers.contains(ghost2 - 1)) {
  //           setState(() {
  //             ghost2--;
  //             ghostLast2 = "left";
  //           });
  //         } else if (!barriers.contains(ghost2 + numberInRow)) {
  //           setState(() {
  //             ghost2 += numberInRow;
  //             ghostLast2 = "down";
  //           });
  //         }
  //       }
  //       break;
  //     case "down":
  //       if (!barriers.contains(ghost2 + numberInRow)) {
  //         setState(() {
  //           ghost2 += numberInRow;
  //           ghostLast2 = "down";
  //         });
  //       } else {
  //         if (!barriers.contains(ghost2 - 1)) {
  //           setState(() {
  //             ghost2--;
  //             ghostLast2 = "left";
  //           });
  //         } else if (!barriers.contains(ghost2 + 1)) {
  //           setState(() {
  //             ghost2++;
  //             ghostLast2 = "right";
  //           });
  //         } else if (!barriers.contains(ghost2 - numberInRow)) {
  //           setState(() {
  //             ghost2 -= numberInRow;
  //             ghostLast2 = "up";
  //           });
  //         }
  //       }
  //       break;
  //   }
  // }

  // void oldMoveGhost3() {
  //   switch (ghostLast) {
  //     case "left":
  //       if (!barriers.contains(ghost3 - 1)) {
  //         setState(() {
  //           ghost3--;
  //         });
  //       } else {
  //         if (!barriers.contains(ghost3 + numberInRow)) {
  //           setState(() {
  //             ghost3 += numberInRow;
  //             ghostLast3 = "down";
  //           });
  //         } else if (!barriers.contains(ghost3 + 1)) {
  //           setState(() {
  //             ghost3++;
  //             ghostLast3 = "right";
  //           });
  //         } else if (!barriers.contains(ghost3 - numberInRow)) {
  //           setState(() {
  //             ghost3 -= numberInRow;
  //             ghostLast3 = "up";
  //           });
  //         }
  //       }
  //       break;
  //     case "right":
  //       if (!barriers.contains(ghost3 + 1)) {
  //         setState(() {
  //           ghost3++;
  //         });
  //       } else {
  //         if (!barriers.contains(ghost3 - numberInRow)) {
  //           setState(() {
  //             ghost3 -= numberInRow;
  //             ghostLast3 = "up";
  //           });
  //         } else if (!barriers.contains(ghost3 - 1)) {
  //           setState(() {
  //             ghost3--;
  //             ghostLast3 = "left";
  //           });
  //         } else if (!barriers.contains(ghost3 + numberInRow)) {
  //           setState(() {
  //             ghost3 += numberInRow;
  //             ghostLast3 = "down";
  //           });
  //         }
  //       }
  //       break;
  //     case "up":
  //       if (!barriers.contains(ghost3 - numberInRow)) {
  //         setState(() {
  //           ghost3 -= numberInRow;
  //           ghostLast3 = "up";
  //         });
  //       } else {
  //         if (!barriers.contains(ghost3 + 1)) {
  //           setState(() {
  //             ghost3++;
  //             ghostLast3 = "right";
  //           });
  //         } else if (!barriers.contains(ghost3 - 1)) {
  //           setState(() {
  //             ghost3--;
  //             ghostLast3 = "left";
  //           });
  //         } else if (!barriers.contains(ghost3 + numberInRow)) {
  //           setState(() {
  //             ghost3 += numberInRow;
  //             ghostLast3 = "down";
  //           });
  //         }
  //       }
  //       break;
  //     case "down":
  //       if (!barriers.contains(ghost3 + numberInRow)) {
  //         setState(() {
  //           ghost3 += numberInRow;
  //           ghostLast3 = "down";
  //         });
  //       } else {
  //         if (!barriers.contains(ghost3 - 1)) {
  //           setState(() {
  //             ghost3--;
  //             ghostLast3 = "left";
  //           });
  //         } else if (!barriers.contains(ghost3 + 1)) {
  //           setState(() {
  //             ghost3++;
  //             ghostLast3 = "right";
  //           });
  //         } else if (!barriers.contains(ghost3 - numberInRow)) {
  //           setState(() {
  //             ghost3 -= numberInRow;
  //             ghostLast3 = "up";
  //           });
  //         }
  //       }
  //       break;
  //   }
  // }

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
            break;
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
            break;
        }
        return;

      case GhostState.leaving:
        if (ghost1LeavingSteps > 0) {
          setState(() {
            ghost1 -= numberInRow;
            ghost1LeavingSteps--;
          });
        } else {
          ghostState = GhostState.active;
          ghost1LeavingSteps =3;
        }
        return;
        break;
      case GhostState.active:
        ghost1AI(player);
        break;
      case GhostState.scatter:
        ghost1AI(ghost1HomeLocation);
        break;
      case GhostState.frightened:
        ghost1AI(Random().nextInt(numberOfSquares));
        break;
      case GhostState.home:
        // TODO: Handle this case.
        throw UnimplementedError();
        break;
    }
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
            break;
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
            break;
        }
        return;


      case GhostState.leaving:
        if (ghost2LeavingSteps > 0) {
          setState(() {
            ghost2 -= numberInRow;
            ghost2LeavingSteps--;
          });
        } else {
          ghostState2 = GhostState.active;
          ghost2LeavingSteps =3;
        }
        return;


      case GhostState.active:
        ghost2AI(player);
        break;
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
            break;
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
            break;
        }
        return;


      case GhostState.leaving:
        if (ghost3LeavingSteps > 0) {
          setState(() {
            ghost3 -= numberInRow;
            ghost3LeavingSteps--;
          });
        } else {
          ghostState3 = GhostState.active;
          ghost3LeavingSteps =3;
        }
        return;


      case GhostState.active:
        ghost3AI(player);
        break;
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
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberInRow),
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
                            break;
                          case "right":
                            return MyPlayer();
                            break;
                          case "up":
                            return Transform.rotate(
                              angle: 3 * pi / 2,
                              child: MyPlayer(),
                            );
                            break;
                          case "down":
                            return Transform.rotate(
                              angle: pi / 2,
                              child: MyPlayer(),
                            );
                            break;
                          default:
                            return MyPlayer();
                            break;
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
                  for(int i = 0; playerLives> i; i++)
                    SizedBox(
                        height: 10,
                        width: 10,
                        child: Image(image: AssetImage("lib/pacman/images/pacman.png"))),
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
