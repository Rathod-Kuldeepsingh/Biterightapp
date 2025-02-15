// ignore_for_file: avoid_print, deprecated_member_use, use_super_parameters, unused_field, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BarcodeSearchScreen(),
//     );
//   }
// }

class BarcodeSearchScreen extends StatefulWidget {
  const BarcodeSearchScreen({super.key});

  @override
  _BarcodeSearchScreenState createState() => _BarcodeSearchScreenState();
}

class _BarcodeSearchScreenState extends State<BarcodeSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _product;
  List<Map<String, dynamic>> _suggestedProducts = [];
  List<String> _searchSuggestions = [];
  bool _isLoading = false;
  String? _errorMessage;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isScanning = false;



   Future<void> saveSearchHistory(String query) async {
    try {
      // Save the search history to Firestore
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('search_history')
            .add({
          'query': query,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving search history: $e');
    }
  }
   Future<void> getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
      });
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('products')
            .where('product_name', isGreaterThanOrEqualTo: query)
            .where('product_name', isLessThanOrEqualTo: '$query\uf8ff') // Prefix matching
            .get();

        setState(() {
          _searchSuggestions = snapshot.docs
              .map((doc) => doc['product_name'] as String)
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }


  Future<void> getProductByBarcode(String barcode) async {
    final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _product = null;
      _suggestedProducts.clear(); // Clear previous suggestions
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 1) {
          setState(() {
            _product = data['product'];
          });
   
         //
         
           saveProductToFirestore(_product!);


          // Fetch suggested products after product is found
          fetchSuggestedProducts(_product!);

          // Navigate to ProductDetailScreen
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
  //

  Future<void> getProductByName(String productName) async {
    final url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$productName&search_simple=1&action=process&json=1';

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _suggestedProducts.clear();
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['count'] > 0) {
          setState(() {
            _suggestedProducts =
                List<Map<String, dynamic>>.from(data['products']);
            
          });
          //  saveSearchHistory(productName);
           if (_suggestedProducts.isNotEmpty) {
          saveProductToFirestore(_product!);
        }
        } else {
          setState(() {
            _errorMessage = 'No products found';
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

  // suggested product show

  Future<void> fetchSuggestedProducts(Map<String, dynamic> product) async {
    // Get the category of the product (e.g., snacks)
    final category =
        product['categories']?.split(',')[0] ?? 'snacks'; // Default to snacks
    final url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$category&search_simple=1&action=process&json=1';

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['count'] > 0) {
          setState(() {
            _suggestedProducts =
                List<Map<String, dynamic>>.from(data['products']);
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

  Future<void> scanBarcode() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        setState(() {
          _errorMessage = 'No image selected';
          _isScanning = false;
        });
        return;
      }

      final InputImage inputImage = InputImage.fromFilePath(pickedFile.path);
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

  Future<void> saveProductToFirestore(Map<String, dynamic> product) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return; // Ensure user is authenticated
  
  try {
    // Save product data to Firestore under the user's collection
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('products').add({
      'product_name': product['product_name'] ?? 'N/A',
      'brands': product['brands'] ?? 'N/A',
      'categories': product['categories'] ?? 'N/A',
      'image_url': product['image_url'] ?? '',
      'ingredients_text': product['ingredients_text'] ?? 'N/A',
      'nutriments': product['nutriments'] ?? {},
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Product saved to Firestore');
  } catch (e) {
    print('Error saving product to Firestore: $e');
  }
}



  @override
  void dispose() {
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xFFF5F5F5),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter barcode',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      hintText: 'Scan or Enter Barcode and Name',
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
                    onChanged: (value) {
                getSuggestions(value); // Fetch suggestions as user types
              },
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            final input = _controller.text.trim();

                            if (input.isNotEmpty) {
                              if (RegExp(r'^[0-9]+$').hasMatch(input)) {
                                // Fixed regex to properly check for numbers
                                getProductByBarcode(input);
                              } else {
                                getProductByName(input);
                              }
                            } else {
                              print(
                                  "Input is empty"); // Handle empty input gracefully
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFF27445D),
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
                  ElevatedButton(
                    onPressed: scanBarcode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
              Column(
                children: [
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
                ],
              ),

              // suggested products
              SizedBox(height: 30),
              Text(
                'You may also like:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  SizedBox(height: 10),
                  if (_suggestedProducts.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _suggestedProducts.length,
                      itemBuilder: (context, index) {
                        final suggestedProduct = _suggestedProducts[index];
                        final suggestedImageUrl = suggestedProduct['image_url'];
                        final suggestedProductName =
                            suggestedProduct['product_name'] ?? 'N/A';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                    product: suggestedProduct),
                              ),
                            );
                          },
                          child: Card(
                            color: Color(0xFFF5F5F5),
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
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.contain,
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
                          ),
                        );
                      },
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nutriments = product['nutriments'] ?? {};
    final imageUrl = product['image_url'];

    return Scaffold(
       backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Product Details'),
          backgroundColor:  Color(0xFFFFFCF2)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
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
              _buildProductCategory(
                  'Product Name', product['product_name'] ?? 'N/A'),
              _buildProductCategory('Brand', product['brands'] ?? 'N/A'),
              _buildProductCategory('Category', product['categories'] ?? 'N/A'),
              _buildProductCategory(
                  'Ingredients', product['ingredients_text'] ?? 'N/A'),
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
              _buildProductCategory('Energy (kcal)',
                  nutriments['energy-kcal']?.toString() ?? 'N/A'),
              _buildProductCategory(
                  'Fat (g)', nutriments['fat']?.toString() ?? 'N/A'),
              _buildProductCategory('Saturated Fat (g)',
                  nutriments['saturated-fat']?.toString() ?? 'N/A'),
              _buildProductCategory('Carbohydrates (g)',
                  nutriments['carbohydrates']?.toString() ?? 'N/A'),
              _buildProductCategory(
                  'Sugars (g)', nutriments['sugars']?.toString() ?? 'N/A'),
              _buildProductCategory(
                  'Protein (g)', nutriments['proteins']?.toString() ?? 'N/A'),
              _buildProductCategory(
                  'Salt (g)', nutriments['salt']?.toString() ?? 'N/A'),
              _buildProductCategory(
                  'Fiber (g)', nutriments['fiber']?.toString() ?? 'N/A'),
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
