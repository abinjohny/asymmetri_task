import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Test App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorSelector(),
          SpeedAdjuster(),
          ItemInput(),
          Expanded(
            child: Center(
              child: LoadingIndicators(),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Text('Select Color: '),
            Obx(
                  () => DropdownButton<String>(
                value: MyFunctions.color.value,
                onChanged: (value) {
                  MyFunctions.changeColor(value!);
                },
                items: ['Green', 'Blue', 'Red', 'Purple'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedAdjuster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adjust Speed:'),
          Obx(
                () => Slider(
              value: MyFunctions.speed.value.toDouble(),
              onChanged: (newValue) {
                MyFunctions.changeSpeed(newValue.toInt());
              },
              min: 1,
              max: 3,
              divisions: 2,
              label: MyFunctions.speedNames[MyFunctions.speed.value - 1],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Items:'),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              MyFunctions.changeTotalItems(int.tryParse(value) ?? 0);
            },
          ),
          SizedBox(height: 16),
          Text('Items in Row:'),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              MyFunctions.changeItemsInRow(int.tryParse(value) ?? 0);
            },
          ),
        ],
      ),
    );
  }
}

class LoadingIndicators extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SingleChildScrollView(
            child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              (MyFunctions.totalItems.value / MyFunctions.itemsInRow.value)
                  .ceil(),
                  (rowIndex) {
                return Row(
                  children: List.generate(
                    MyFunctions.itemsInRow.value,
                        (index) {
                      final totalProgressIndicators = MyFunctions.totalItems.value;
                      final totalInRow = MyFunctions.itemsInRow.value;
                      final startIndex = rowIndex * totalInRow;
                      final linearIndex = startIndex + index;
                      if (linearIndex >= totalProgressIndicators) {
                        return SizedBox(); // Return an empty container if we exceed the total items
                      }
                      return Expanded(
                        child: AnimatedLinearProgressIndicator(
                          color: MyFunctions.color.value == 'Green'
                              ? Colors.green
                              : MyFunctions.color.value == 'Blue'
                              ? Colors.blue
                              : MyFunctions.color.value == 'Red'
                              ? Colors.red
                              : Colors.purple,
                          speed: MyFunctions.speed.value,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
                    ),
                  ),
          ),
    );
  }
}

class AnimatedLinearProgressIndicator extends StatelessWidget {
  final Color color;
  final int speed;

  AnimatedLinearProgressIndicator({
    required this.color,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    double duration;
    if (speed == 1) {
      duration = 4000;
    } else if (speed == 2) {
      duration = 2000;
    } else {
      duration = 1000;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: duration.toInt()),
      builder: (context, value, child) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            value: value,
          ),
        );
      },
    );
  }
}

class MyFunctions {
  static var color = 'Green'.obs;
  static var speed = 2.obs;
  static var totalItems = 5.obs;
  static var itemsInRow = 5.obs;

  static List<String> speedNames = ['Slow', 'Smooth', 'Fast'];

  static void changeColor(String newColor) {
    color.value = newColor;
  }

  static void changeSpeed(int newSpeed) {
    speed.value = newSpeed;
  }

  static void changeTotalItems(int newTotalItems) {
    totalItems.value = newTotalItems > 15 ? 15 : newTotalItems;
  }

  static void changeItemsInRow(int newItemsInRow) {
    itemsInRow.value = newItemsInRow;
  }
}