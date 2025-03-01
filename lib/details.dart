// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ProductFilterScreen extends StatefulWidget {
//   @override
//   _ProductFilterScreenState createState() => _ProductFilterScreenState();
// }

// class _ProductFilterScreenState extends State<ProductFilterScreen> {
//   // List of available categories
//  List<String> categories = [
//     'Snacks',
//     'Chocolates',
//     'Beverages',
//     'Drinks',
//     'Vegan',
//     'Organic',
//     'Low-Fat',
//     'Sugar-Free',
//     'Gluten-Free',
//     'Low-Calorie'
//   ];

//   // Selected categories
//   List<String> selectedCategories = [];

//   // List to store fetched products
//   List<Map<String, dynamic>> products = [];

//   showLoader() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Center(
//             child: CircularProgressIndicator(
//           color: Colors.black,
//         ));
//       },
//     );
//   }

//   closeLoader() {
//     Navigator.pop(context);
//   }
  

//   // Function to fetch products from OpenFoodFacts API
//   Future<void> fetchProductsFromAPI() async {
//     print('Fetching products from API...');
//     showLoader();
//     List<Map<String, dynamic>> allProducts = [];

//     for (String category in selectedCategories) {
//       final response = await http.get(
//            Uri.parse(
//             "https://world.openfoodfacts.org/cgi/search.pl?search_terms=$category&search_simple=1&action=process&json=1"),
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         List productsList = data['products'] ?? [];

//         for (var product in productsList) {
//           if (product["product_name"] != null) {
//             allProducts.add({
//               "product_name": product["product_name"],
//               "image_url": product["image_url"],
//               "brands": product["brands"] ?? "N/A",
//               "categories": product["categories"] ?? "N/A",
//               "ingredients_text": product["ingredients_text"] ?? "N/A",
//               "nutriments": product["nutriments"] ?? {},
//             });
//           }
//         }
//       }
//     }

//     setState(() {
//       products = allProducts;
//     });

//     debugPrint("Fetched Products: ${products.length}");
//     closeLoader();
//   }


 
//   // Show category filter bottom sheet
//   void showCategoryFilter() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return Container(
//               padding: EdgeInsets.all(10),
//               height: 400,
//               child: Column(
//                 children: [
//                   Text("Select Categories",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Expanded(
//                     child: ListView(
//                       children: categories.map((category) {
//                         return CheckboxListTile(
//                           title: Text(category),
//                           value: selectedCategories.contains(category),
//                           onChanged: (bool? value) {
//                             setModalState(() {
//                               if (value == true) {
//                                 selectedCategories.add(category);
//                               } else {
//                                 selectedCategories.remove(category);
//                               }
//                             });
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       fetchProductsFromAPI();
//                     },
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor:Color(0xFF27445D) ),
//                     child: Text("Apply Filter",style: 
//                     TextStyle(color: Colors.white,
//                     fontWeight: FontWeight.bold),),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Filtered Products"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: showCategoryFilter,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Display Fetched Products
//           Expanded(
//             child: products.isEmpty
//                 ? Center(child: Text("No products found. Click filter to select categories."))
//                 : ListView.builder(
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       var product = products[index];
//                       return Card(
//                         margin: EdgeInsets.all(10),
//                         child: ListTile(
//                           title: Text(product['product_name']),
//                           leading: product['image_url'] != null
//                               ? Image.network(product['image_url'], width: 50, height: 50, fit: BoxFit.cover)
//                               : Icon(Icons.fastfood, size: 50),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
