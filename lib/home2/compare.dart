import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';
class ProductComparisonScreen extends StatefulWidget {
  const ProductComparisonScreen({super.key});

  @override
  _ProductComparisonScreenState createState() =>
      _ProductComparisonScreenState();
}

class _ProductComparisonScreenState extends State<ProductComparisonScreen> {
  final TextEditingController _product1Controller = TextEditingController();
  final TextEditingController _product2Controller = TextEditingController();

  CameraController? _cameraController;
  bool isScanning = false;
  
  Future<void> _scanBarcode(TextEditingController controller) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    setState(() {
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
    });

    await _cameraController?.initialize();

    final scanner = BarcodeScanner();
    isScanning = true;

    while (isScanning) {
      try {
        final image = await _cameraController!.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final barcodes = await scanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          controller.text = barcodes.first.rawValue ?? "";
          isScanning = false;
          scanner.close();
          break;
        }
      } catch (e) {
        print("Barcode scanning error: $e");
      }
    }

    setState(() {
      isScanning = false;
      _cameraController?.dispose();
      _cameraController = null;
    });
  }

  Map<String, dynamic>? product1;
  Map<String, dynamic>? product2;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _fetchProductDetails() async {
    final product1Barcode = _product1Controller.text.trim();
    final product2Barcode = _product2Controller.text.trim();

    if (product1Barcode.isEmpty || product2Barcode.isEmpty) {
      setState(() => errorMessage = "Please enter both product barcodes.");
      return;
    }

    setState(() {
      isLoading = true;
      product1 = null;
      product2 = null;
      errorMessage = null;
    });

    try {
      final response1 = await http.get(Uri.parse(
          'https://world.openfoodfacts.org/api/v0/product/$product1Barcode.json'));
      final response2 = await http.get(Uri.parse(
          'https://world.openfoodfacts.org/api/v0/product/$product2Barcode.json'));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final data1 = json.decode(response1.body);
        final data2 = json.decode(response2.body);

        setState(() {
          product1 = data1['product'];
          product2 = data2['product'];
        });

        if (product1 == null || product2 == null) {
          setState(() => errorMessage = "One or both products were not found.");
        }
      } else {
        setState(() => errorMessage = "Failed to fetch product details.");
      }
    } catch (e) {
      setState(() => errorMessage = "Error fetching product details: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _determineHealthierProduct() {
    String? score1 = product1?['nutriscore_grade'];
    String? score2 = product2?['nutriscore_grade'];

    if (score1 == null || score2 == null)
      return "Health score not available for both products.";

    Map<String, int> scoreRank = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5};

    int rank1 = scoreRank[score1.toLowerCase()] ?? 6;
    int rank2 = scoreRank[score2.toLowerCase()] ?? 6;

    if (rank1 < rank2) {
      return "${product1!['product_name']} is healthier based on Nutri-Score.";
    } else if (rank1 > rank2) {
      return "${product2!['product_name']} is healthier based on Nutri-Score.";
    } else {
      return "Both products have the same health rating.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Compare Products',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        backgroundColor: const Color(0xFF27445D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              _buildTextField(
                  _product1Controller, 'Enter First Product Barcode'),
              const SizedBox(height: 30),
              _buildTextField(
                  _product2Controller, 'Enter Second Product Barcode'),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _fetchProductDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xFF27445D),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Compare', style: TextStyle(fontSize: 16,
                       color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              if (product1 != null && product2 != null) ...[
                _buildComparisonTable(
                    product1!['nutriments'], product2!['nutriments']),
                const SizedBox(height: 20),
                _buildComparisonChart(
                    product1!['nutriments'], product2!['nutriments']),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _determineHealthierProduct(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        // IconButton(
        //   icon: Icon(Icons.qr_code_scanner, color: Colors.blue),
        //   onPressed: () => _scanBarcode(controller),
        // ),
      ],
    );
  }


  Widget _buildComparisonTable(
      Map<String, dynamic> nutriments1, Map<String, dynamic> nutriments2) {
    final nutrients = [
      'energy-kcal',
      'fat',
      'saturated-fat',
      'carbohydrates',
      'sugars',
      'proteins',
      'salt',
      'fiber'
    ];
      @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.5),
          },
          children: [
            _buildTableRow('Nutrient', product1!['product_name'] ?? 'Product 1',
                product2!['product_name'] ?? 'Product 2',
                isHeader: true),
            for (var nutrient in nutrients)
              _buildTableRow(
                nutrient.replaceAll('-', ' ').toUpperCase(),
                '${nutriments1[nutrient]?.toDouble() ?? 0.0} g',
                '${nutriments2[nutrient]?.toDouble() ?? 0.0} g',
              ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value1, String value2,
      {bool isHeader = false}) {
    return TableRow(
      decoration:
          isHeader ? const BoxDecoration(color: Color(0xFF27445D),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))) : null,
      children: [
        _tableCell(label, isHeader: isHeader, isBold: true),
        _tableCell(value1, isHeader: isHeader),
        _tableCell(value2, isHeader: isHeader),
      ],
    );
  }

  Widget _tableCell(String text, {bool isHeader = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 16 : 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildComparisonChart(
      Map<String, dynamic> nutriments1, Map<String, dynamic> nutriments2) {
    final labels = [
      'Energy',
      'Fat',
      'S.Fat',
      'Carbs',
      'Sugar',
      'Protein',
      'Salt',
      'Fiber'
    ];
    final values1 = labels
        .map((label) =>
            nutriments1[label.toLowerCase().replaceAll(' ', '-')]?.toDouble() ??
            0.0)
        .toList();
    final values2 = labels
        .map((label) =>
            nutriments2[label.toLowerCase().replaceAll(' ', '-')]?.toDouble() ??
            0.0)
        .toList();
    final maxValue = (values1 + values2).reduce((a, b) => a > b ? a : b) + 5;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue,
              barGroups: List.generate(labels.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                        toY: values1[index], color: Colors.blue, width: 8),
                    BarChartRodData(
                        toY: values2[index], color: Colors.red, width: 8),
                  ],
                );
              }),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}
