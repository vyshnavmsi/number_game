import 'package:flutter/material.dart';

class NumberDragDropPage extends StatefulWidget {
  @override
  _NumberDragDropPageState createState() => _NumberDragDropPageState();
}

class _NumberDragDropPageState extends State<NumberDragDropPage> {
  int currentLevel = 1;
  List<int> numbers = [];
  List<int> shuffledNumbers = [];
  List<int?> dropTargets = [];
  bool isGameCompleted = false;

  @override
  void initState() {
    super.initState();
    initializeGame(); // Initialize the game for the first level
  }

  void initializeGame() {
    numbers = generateSequence(currentLevel);
    shuffledNumbers = List.from(numbers)..shuffle();
    dropTargets = List.generate(numbers.length, (index) => null);
    isGameCompleted = false;
  }

  List<int> generateSequence(int level) {
    if (level case 2) {
      return List.generate(6, (index) => (index + 1) * 2);
    } else if (level case 3) {
      return List.generate(6, (index) => index * index);
    } else if (level case 4) {
      return List.generate(6, (index) => (index + 1) * 3);
    } else if (level case 5) {
      return List.generate(6, (index) => index * 5);
    } else {
      return List.generate(7, (index) => index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Number Arrangement Game',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Level indicator
              Text(
                'Level $currentLevel',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 64, 120, 65)),
              ),
              SizedBox(height: 20),
              // Instruction
              Text(
                'Arrange the numbers in ascending order',
                style: TextStyle(fontSize: 20, color: Colors.teal),
              ),
              SizedBox(height: 30),
              // Display shuffled numbers as draggable items
              Wrap(
                spacing: 20.0,
                runSpacing: 13.0,
                children: List.generate(
                  shuffledNumbers.length,
                  (index) => Draggable<int>(
                    data: shuffledNumbers[index],
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 14, 107, 62),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${shuffledNumbers[index]}',
                            style:
                                TextStyle(fontSize: 32, color: Colors.white)),
                      ),
                    ),
                    childWhenDragging: Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Text('${shuffledNumbers[index]}',
                          style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 14, 107, 62),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text('${shuffledNumbers[index]}',
                          style: TextStyle(fontSize: 22, color: Colors.white)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Display drop targets
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: List.generate(
                  dropTargets.length,
                  (index) => DragTarget<int>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color.fromARGB(255, 235, 239, 239),
                              width: 2),
                        ),
                        child: dropTargets[index] == null
                            ? Text('Drop',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                            : Text('${dropTargets[index]}',
                                style: TextStyle(
                                    fontSize: 32, color: Colors.white)),
                      );
                    },
                    onWillAcceptWithDetails: (data) {
                      return true;
                    },
                    onAcceptWithDetails: (details) {
                      handleDrop(details.data, index);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Game completion message
              if (isGameCompleted)
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    currentLevel == 5
                        ? 'Congratulations! You completed all levels!'
                        : 'Well Done! Proceeding to next level...',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                height: 8,
              ),
              if (isGameCompleted && currentLevel < 5)
                ElevatedButton(
                  onPressed: nextLevel,
                  child: Text('Next Level'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void handleDrop(int number, int targetIndex) {
    setState(() {
      dropTargets[targetIndex] = number;
    });

    if (checkIfSorted()) {
      setState(() {
        isGameCompleted = true;
      });
    }
  }

  bool checkIfSorted() {
    for (int i = 0; i < dropTargets.length; i++) {
      if (dropTargets[i] == null || dropTargets[i] != numbers[i]) {
        return false;
      }
    }
    return true;
  }

  void nextLevel() {
    if (currentLevel < 5) {
      setState(() {
        currentLevel++;
        initializeGame();
      });
    } else {
      setState(() {
        isGameCompleted = true;
      });
    }
  }

  void resetGame() {
    setState(() {
      currentLevel = 1;
      initializeGame();
    });
  }
}
