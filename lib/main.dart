import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blood Sugar Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        popupMenuTheme: PopupMenuThemeData(color: Colors.grey[200]),
      ),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatelessWidget {
  final BloodSugarController _controller = Get.put(BloodSugarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 99, 155, 223),
        title: const Text(
          'Input Blood Sugar Data',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller.beforeMealController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Before Meal (mg/dL)',
                ),
              ),
              TextField(
                controller: _controller.afterMealController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'After Meal (mg/dL)',
                ),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  if (_controller.validateData()) {
                    Get.to(InfoScreen());
                  } else {
                    Get.snackbar(
                      'Error',
                      'Invalid blood sugar data',
                      backgroundColor: const Color.fromARGB(255, 99, 155, 223),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 99, 155, 223),
                ), //Create button to view category information
                child: const Text(
                  'Show Info',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  final BloodSugarController _controller = Get.find();

  List<String> determineCategories(double beforeMeal, double afterMeal) { //check category information
    List<String> matchingCategories = [];

    if (beforeMeal >= 80 && beforeMeal <= 130 && afterMeal < 180) {
      matchingCategories.add('Adults with type 1 & 2 diabetes');
    }
    if (beforeMeal >= 90 && beforeMeal <= 130 && afterMeal < 140) {
      matchingCategories.add('Children with type 1 diabetes');
    }
    if (beforeMeal < 95 && afterMeal <= 120) {
      matchingCategories.add('Pregnant people (T1D, gestational diabetes)');
    }
    if (beforeMeal >= 80 &&
        beforeMeal <= 180 &&
        afterMeal >= 80 &&
        afterMeal <= 200) {
      matchingCategories.add('65 or older');
    }
    if (beforeMeal <= 99 && afterMeal <= 140) {
      matchingCategories.add('Without diabetes');
    }

    return matchingCategories;
  }

  @override
  Widget build(BuildContext context) {
    double beforeMeal =
        double.tryParse(_controller.beforeMealController.text) ?? 0;
    double afterMeal =
        double.tryParse(_controller.afterMealController.text) ?? 0;

    List<String> matchingCategories =
        determineCategories(beforeMeal, afterMeal);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 99, 155, 223),
        title: const Text(
          'Category Information',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (String category in matchingCategories)
                Text(
                  category,
                  style: const TextStyle(fontSize: 20),
                ),
              if (matchingCategories.isEmpty)
                const Text(
                  'No category found',
                  style: TextStyle(fontSize: 20),
                ),
              const SizedBox(height: 100),
              Table(
                border: TableBorder.all(), //Draw Table in Info screen
                children: const [
                  TableRow(
                    children: [
                      TableCell(child: SizedBox()),
                      TableCell(
                          child: Text('Before Meal (mg/dL)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w900))),
                      TableCell(
                          child: Text('After Meal (mg/dL)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w900))),
                      TableCell(
                          child: Text('Other',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w900))),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(
                        'Adults with type 1 & 2 diabetes',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '80-130',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '< 180 (1 or 2 hours after)',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(child: SizedBox()),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(
                        'Children with type 1 diabetes',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '90-130',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(child: SizedBox()),
                      TableCell(
                          child: Text(
                        '90-150 at Bedtime/overnight',
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(
                        'Pregnant people (T1D, gestational diabetes)',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '< 95',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '<= 140 (1 hour after)',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '<= 120 (2 hours after)',
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(
                        '65 or older',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '80-180',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(child: SizedBox()),
                      TableCell(
                          child: Text(
                        '80–200 for those in poorer health, assisted living, end of life',
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(
                        'Without diabetes',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '<= 99',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        '<= 140',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BloodSugarController extends GetxController {
  TextEditingController beforeMealController = TextEditingController();
  TextEditingController afterMealController = TextEditingController();

  bool validateData() {
    double beforeMeal = double.tryParse(beforeMealController.text) ?? 0;
    double afterMeal = double.tryParse(afterMealController.text) ?? 0;

    // Validate input data
    if (beforeMeal <= 0 || afterMeal <= 0) {
      return false;
    }

    return true;
  }
}
