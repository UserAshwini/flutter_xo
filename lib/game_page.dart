import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  static const String player_X = 'X';
  static const String player_Y = 'Y';

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override

  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame(){
    currentPlayer = player_X;
    gameEnd = false;
    occupied = ["","","","","","","","",""];
  }
  
  Widget _headerText(){
    return  Column(
      children: [
        const Text('Tic Tac Toe',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(91, 120, 196, 1),
        ),),
        Text("$currentPlayer turn",
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(221, 149, 173, 1),
        ),),
      ],
    );
  }

  Widget _gameContainer(){
    return Container(
      // height: MediaQuery.of(context).size.height*.6,
      // width: MediaQuery.of(context).size.width*.7,
      height: 400,
      width: 400,
      margin: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
        itemCount: 9,
        itemBuilder: (context, int index){
          return _box(index);
        }),
    );
  }

  Widget _box(int index){
    return InkWell(
      onTap: (){
        if(gameEnd || occupied[index].isNotEmpty){
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        color: occupied[index].isEmpty?const Color.fromARGB(255, 170, 186, 194): occupied[index]==player_X?Colors.deepOrange:Colors.deepPurple,
        margin: EdgeInsets.all(5),
        child: Center(child: Text( occupied[index] ,
        style: TextStyle(
          fontSize: 50,
        ),)),
      ),
    );
  }

  _restartButton(){
    return ElevatedButton(
      onPressed: (){
        setState(() {
          initializeGame();
        });
      }, 
      child: Text('Play Again'));
  }

  changeTurn(){
    if (currentPlayer == player_X){
      currentPlayer = player_Y;
    }else{
      currentPlayer = player_X;
    }
  }

  checkForWinner(){
    List<List<int>> winningList = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6]
    ];
    for(var winningPos in winningList){
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if(playerPosition0.isNotEmpty){
        if(playerPosition0 == playerPosition1 && playerPosition0 == playerPosition2){
          showGameOverMessage("Player $playerPosition0 won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  checkForDraw(){
    if (gameEnd){
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied){
      if(occupiedPlayer.isEmpty){
        draw = false;
      }
    }
    if(draw){
      showGameOverMessage("Draw Match");
      gameEnd = true; 
    }
  }

  showGameOverMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 181, 198, 79),
      content: Text("Game over\n $message",
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(91, 120, 196, 1),
    ),)));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(),
            _gameContainer(),
            _restartButton()
          ],
        ),
      ),
    );
  }
}