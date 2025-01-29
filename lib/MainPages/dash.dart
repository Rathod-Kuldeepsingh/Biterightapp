// mainpage
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
home: BarcodeSearchScreen(),
);
}
}

class BarcodeSearchScreen extends StatefulWidget {
const BarcodeSearchScreen({super.key});

@override
_BarcodeSearchScreenState createState() => _BarcodeSearchScreenState();
}

class _BarcodeSearchScreenState extends State<BarcodeSearchScreen> {
final TextEditingController _controller = TextEditingController();
Map<String, dynamic>? _product;

List<Map<String, dynamic>> _suggestedProducts = [];
bool _isLoading = false;
String? _errorMessage;
final BarcodeScanner _barcodeScanner = BarcodeScanner(); // Initialize barcode scanner
bool _isScanning = false;

// Fetch product data by barcode from Open Food Facts API
Future<void> getProductByBarcode(String barcode) async {
final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

setState(() {
_isLoading = true;
_errorMessage = null;
_product = null;
});

try {
final response = await http.get(Uri.parse(url));

if (response.statusCode == 200) {
final data = json.decode(response.body);

if (data['status'] == 1) {
setState(() {
_product = data['product'];
});

// After product is fetched, navigate to the new screen
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => ProductDetailScreen(product: _product!),
),
);
} else {
setState(() {
_errorMessage = 'Product not found';
});
}
} else {
setState(() {
_errorMessage = 'Failed to load product data';
});
}
} catch (e) {
setState(() {
_errorMessage = 'Error: $e';
});
} finally {
setState(() {
_isLoading = false;
});
}
}

Future<void> fetchSuggestedProducts(Map<String, dynamic> product) async {
final category = product['categories']?.split(',')[0] ?? 'snacks';
final url =
'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$category&search_simple=1&action=process&json=1&page_size=50';

setState(() {
_isLoading = true;
_errorMessage = null;
});

try {
final response = await http.get(Uri.parse(url));

if (response.statusCode == 200) {
final data = json.decode(response.body);

if (data['products'] != null && data['products'].isNotEmpty) {
setState(() {
_suggestedProducts = List<Map<String, dynamic>>.from(data['products'].take(50));
});
} else {
setState(() {
_errorMessage = 'No suggested products found';
});
}
} else {
setState(() {
_errorMessage = 'Failed to fetch suggestions';
});
}
} catch (e) {
setState(() {
_errorMessage = 'Error: $e';
});
} finally {
setState(() {
_isLoading = false;
});
}
}



// Function to scan barcode using ML Kit
Future<void> scanBarcode() async {
setState(() {
_isScanning = true;
_errorMessage = null;
});

try {
// Use image_picker to select an image from the gallery or capture with the camera
final ImagePicker picker = ImagePicker();
final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

if (pickedFile == null) {
setState(() {
_errorMessage = 'No image selected';
_isScanning = false;
});
return;
}

// Convert the picked image to InputImage
final InputImage inputImage = InputImage.fromFilePath(pickedFile.path);

// Process the image using the barcode scanner
final barcodes = await _barcodeScanner.processImage(inputImage);

if (barcodes.isNotEmpty) {
final scannedBarcode = barcodes.first.rawValue ?? '';
setState(() {
_controller.text = scannedBarcode;
});
getProductByBarcode(scannedBarcode);
} else {
setState(() {
_errorMessage = 'No barcode detected';
});
}
} catch (e) {
setState(() {
_errorMessage = 'Error scanning barcode: $e';
});
} finally {
setState(() {
_isScanning = false;
});
}
}

@override
void dispose() {
_barcodeScanner.close(); // Release the barcode scanner resources
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: Padding(
padding: const EdgeInsets.all(16.0),
child: SingleChildScrollView(
child: Column(
children: [
SizedBox(height: 50),
TextField(
controller: _controller,
decoration: InputDecoration(
labelText: 'Enter barcode',
labelStyle: TextStyle(
color: Colors.black,
fontSize: 16,
fontWeight: FontWeight.bold),
hintText: 'Scan or Enter Barcode',
hintStyle: TextStyle(
color: Colors.blueGrey.withOpacity(0.6),
fontSize: 14,
),
filled: true,
fillColor: Colors.white.withOpacity(0.1),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: Colors.black, width: 1.5),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: Colors.black, width: 2.0),
),
prefixIcon: Padding(
padding: const EdgeInsets.symmetric(horizontal: 12.0),
child: Icon(
Icons.search,
color: Colors.black,
),
),
contentPadding:
EdgeInsets.symmetric(vertical: 16, horizontal: 20),
),
keyboardType: TextInputType.number,
),
SizedBox(height: 40),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
// Fetch Product Button
ElevatedButton(
onPressed: _isLoading
? null
: () {
final barcode = _controller.text.trim();
if (barcode.isNotEmpty) {
getProductByBarcode(barcode);
}
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.lightBlueAccent,
padding:
EdgeInsets.symmetric(horizontal: 24, vertical: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: _isLoading
? CircularProgressIndicator(color: Colors.white)
: Text(
'Fetch Product',
style: TextStyle(
color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
// Scan Barcode Button
ElevatedButton(
onPressed: scanBarcode,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.black,
padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: Text(
'Scan Barcode',
style: TextStyle(
color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
],
),
SizedBox(height: 20),
if (_errorMessage != null)
Text(
_errorMessage!,
style: GoogleFonts.roboto(
textStyle: TextStyle(
fontSize: 17,
fontWeight: FontWeight.w600,
color: Colors.red,
),
),
),
SizedBox(height: 30),
Text(
'You may also like:',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
SizedBox(height: 10),
if (_suggestedProducts.isNotEmpty) // Display suggested products
SizedBox(
height: 300, // Adjust the height as needed
child: GridView.builder(
shrinkWrap: true,
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2, // Number of columns in the grid
crossAxisSpacing: 10.0,
mainAxisSpacing: 10.0,
childAspectRatio: 0.75,
),
itemCount: _suggestedProducts.length,
itemBuilder: (context, index) {
final suggestedProduct = _suggestedProducts[index];
final suggestedImageUrl = suggestedProduct['image_url'];
final suggestedProductName = suggestedProduct['product_name'] ?? 'N/A';

return Card(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
elevation: 4,
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
if (suggestedImageUrl != null)
Image.network(
suggestedImageUrl,
height: 100,
width: 100,
fit: BoxFit.cover,
),
SizedBox(height: 8),
Text(
suggestedProductName,
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
overflow: TextOverflow.ellipsis,
),
],
),
);
},
),
),

],
),
),
),

);
}
}

class ProductDetailScreen extends StatelessWidget {
final Map<String, dynamic> product;

const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

@override
Widget build(BuildContext context) {
final nutriments = product['nutriments'] ?? {};
final imageUrl = product['image_url'];

return Scaffold(
appBar: AppBar(
title: Text('Product Details'),
),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Image with proper fitting and size
if (imageUrl != null)
ClipRRect(
borderRadius: BorderRadius.circular(12),
child: Image.network(
imageUrl,
height: 250,
width: double.infinity,
fit: BoxFit.fitHeight,
),
),
SizedBox(height: 20),
Divider(color: Colors.blueAccent, thickness: 1.5),
Text(
'Product Overview',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: Colors.blueAccent,
),
),
SizedBox(height: 24),
_buildProductCategory('Product Name', product['product_name'] ?? 'N/A'),
_buildProductCategory('Brand', product['brands'] ?? 'N/A'),
_buildProductCategory('Category', product['categories'] ?? 'N/A'),
_buildProductCategory('Ingredients', product['ingredients_text'] ?? 'N/A'),
SizedBox(height: 30),
Divider(color: Colors.blueAccent, thickness: 1.5),
SizedBox(height: 20),
Text(
'Nutrition Information',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.blueAccent,
),
),
_buildProductCategory('Energy (kcal)', nutriments['energy-kcal']?.toString() ?? 'N/A'),
_buildProductCategory('Fat (g)', nutriments['fat']?.toString() ?? 'N/A'),
_buildProductCategory('Saturated Fat (g)', nutriments['saturated-fat']?.toString() ?? 'N/A'),
_buildProductCategory('Carbohydrates (g)', nutriments['carbohydrates']?.toString() ?? 'N/A'),
_buildProductCategory('Sugars (g)', nutriments['sugars']?.toString() ?? 'N/A'),
_buildProductCategory('Protein (g)', nutriments['proteins']?.toString() ?? 'N/A'),
_buildProductCategory('Salt (g)', nutriments['salt']?.toString() ?? 'N/A'),
_buildProductCategory('Fiber (g)', nutriments['fiber']?.toString() ?? 'N/A'),
],
),
),
),
);
}

Widget _buildProductCategory(String category, String value) {
return Padding(
padding: const EdgeInsets.only(bottom: 12.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
category,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),
SizedBox(height: 5),
Text(
value,
style: TextStyle(fontSize: 16, color: Colors.black54),
),
],
),
);
}
}