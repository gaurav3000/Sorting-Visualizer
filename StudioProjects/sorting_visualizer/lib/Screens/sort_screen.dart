import 'dart:ui';
import 'package:sorting_visualizer/reusable_card.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SortScreen extends StatefulWidget {
  @override
  _SortScreenState createState() => _SortScreenState();
}

enum Algorithms {
  bubbleSort,
  selectionSort,
  insertionSort,
  cocktailSort,
}

Color inactiveColor = Colors.grey.shade900;
Color activeColor = Colors.grey.shade800;

class _SortScreenState extends State<SortScreen> {
  List<int> heights = [];
  int sizeOfHeights = 10;
  bool working = true;
  int index1 = 0;
  int index2 = 0;
  int speed = 500;
  int maxSpeed = 1001;

  Algorithms selectedAlgorithm = Algorithms.bubbleSort;

  void generateHeights() {
    heights = [];
    Random random = new Random();
    for (int i = 0; i < sizeOfHeights; i++) {
      int height = random.nextInt(350);
      heights.add(height);
    }
  }

  void bubbleSort() async {
    int n = heights.length;
    working = false;
    for (int i = 0; i < n; i++) {
      for (int j = n - 1; j >= i + 1; j--) {
        if (heights[j - 1] > heights[j]) {
          var temp = heights[j - 1];
          heights[j - 1] = heights[j];
          heights[j] = temp;
        }
        setState(() {
          index1 = j - 1;
          index2 = j - 2;
        });
        int actualSpeed = maxSpeed - speed;
        await Future.delayed(Duration(milliseconds: actualSpeed));
        setState(() {});
      }
    }
    setState(() {
      working = true;
    });
  }

  void selectionSort() async {
    working = false;
    int n = heights.length;
    int shortest = 0;
    for (int i = 0; i < n - 1; i++) {
      shortest = i;
      for (int j = i + 1; j < n; j++) {
        int actualSpeed = maxSpeed - speed;
        setState(() {
          index1 = shortest;
          index2 = j;
        });
        await Future.delayed(Duration(milliseconds: actualSpeed));

        if (heights[j] < heights[shortest]) {
          shortest = j;
        }
      }
      setState(() {
        var temp = heights[shortest];
        heights[shortest] = heights[i];
        heights[i] = temp;
      });
    }
    working = true;
  }

  void insertionSort() async {
    setState(() {
      working = false;
    });
    int key = 0;
    int n = heights.length;
    for (int i = 1; i < n; i++) {
      key = heights[i];
      int j = i - 1;
      while (j >= 0 && heights[j] > key) {
        setState(() {
          index1 = j;
          index2 = j + 1;
          heights[j + 1] = heights[j];
          j--;
        });
        int actualSpeed = maxSpeed - speed;
        await Future.delayed(Duration(milliseconds: actualSpeed));
        setState(() {});
      }
      heights[j + 1] = key;
    }
    setState(() {
      working = true;
    });
  }

  void cocktailSort() async{
    setState(() {
      working = false;
    });
    bool swapped = true;
    int start = 0;
    int end = heights.length;

    while (swapped == true) {
      swapped = false;

      for (int i = start; i < end - 1; ++i) {
        if (heights[i] > heights[i + 1]) {
          int temp = heights[i];
          heights[i] = heights[i + 1];
          heights[i + 1] = temp;
          swapped = true;
        }
        index1 = i + 1;
        index2 = i + 2;
        int actualSpeed = maxSpeed - speed;
        await Future.delayed(Duration(milliseconds: actualSpeed));
        setState(() {});
      }
      if (swapped == false) break;

      swapped = false;

      end = end - 1;

      for (int i = end - 1; i >= start; i--) {
        if (heights[i] > heights[i + 1]) {
          int temp = heights[i];
          heights[i] = heights[i + 1];
          heights[i + 1] = temp;
          swapped = true;
        }
        index1 = i - 1;
        index2 = i;
        int actualSpeed = maxSpeed - speed;
        await Future.delayed(Duration(milliseconds: actualSpeed));
        setState(() {});
      }
      start = start + 1;
    }
    setState(() {
      working = true;
    });
  }

  @override
  void initState() {
    super.initState();
    generateHeights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorting'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: CustomPaint(
                painter: SortLines(
                    heights: heights,
                    width: MediaQuery.of(context).size.width / sizeOfHeights,
                    index1: index1,
                    index2: index2),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAlgorithm = Algorithms.bubbleSort;
                            });
                          },
                          child: ReusableCard(
                            text: 'Bubble Sort',
                            color: selectedAlgorithm == Algorithms.bubbleSort
                                ? activeColor
                                : inactiveColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAlgorithm = Algorithms.selectionSort;
                            });
                          },
                          child: ReusableCard(
                            text: 'Selection Sort',
                            color: selectedAlgorithm == Algorithms.selectionSort
                                ? activeColor
                                : inactiveColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAlgorithm = Algorithms.insertionSort;
                            });
                          },
                          child: ReusableCard(
                            text: 'Insertion Sort',
                            color: selectedAlgorithm == Algorithms.insertionSort
                                ? activeColor
                                : inactiveColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAlgorithm = Algorithms.cocktailSort;
                            });
                          },
                          child: ReusableCard(
                            text: 'Cocktail Sort',
                            color: selectedAlgorithm == Algorithms.cocktailSort
                                ? activeColor
                                : inactiveColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: working
                              ? () {
                            setState(() {
                              if (selectedAlgorithm ==
                                  Algorithms.bubbleSort) {
                                bubbleSort();
                              } else if (selectedAlgorithm ==
                                  Algorithms.selectionSort) {
                                selectionSort();
                              } else if (selectedAlgorithm ==
                                  Algorithms.insertionSort) {
                                insertionSort();
                              }
                              else if(selectedAlgorithm == Algorithms.cocktailSort){
                                cocktailSort();
                              }
                            });
                          }
                              : null,
                          icon: Icon(Icons.arrow_right),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Size',
                              ),
                              Slider.adaptive(
                                  value: sizeOfHeights.toDouble(),
                                  min: 10,
                                  max: 100,
                                  divisions: 9,
                                  label: '$sizeOfHeights',
                                  onChanged: working ? (newValue) {
                                    setState(() {
                                      sizeOfHeights = newValue.toInt();
                                      generateHeights();
                                    });
                                  }
                                  : null),
                              Text(
                                'Speed',
                              ),
                              Slider(
                                  value: speed.toDouble(),
                                  min: 2,
                                  max: 1000,
                                  onChanged: (newValue) {
                                    setState(() {
                                      speed = newValue.toInt();
                                    });
                                  }),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: working
                              ? () {
                            setState(() {
                              generateHeights();
                            });
                          }
                              : null,
                          icon: Icon(Icons.reset_tv),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SortLines extends CustomPainter {
  SortLines(
      {required this.heights,
        required this.width,
        required this.index1,
        required this.index2});

  List<int> heights = [];
  double width;
  int index1;
  int index2;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-width * heights.length / 2 + (width / 2), 0);
    Paint paint = Paint();
    paint.color = Colors.pink;
    paint.strokeWidth = width;

    for (int i = 0; i < heights.length; i++) {
      if (i == index1) {
        paint.color = Colors.lightBlue;
      }
      if (i == index2) {
        paint.color = Colors.blueAccent;
      }
      canvas.drawLine(
        Offset(i * width, size.height),
        Offset(i * width, size.height - heights[i].toDouble()),
        paint,
      );
      paint.color = Colors.pink;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
