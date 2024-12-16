import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Fetch products with categories and images from the backend
  Future<List> fetchProducts() async {
    var url = Uri.parse("http://192.168.1.4/smartstock_app/backend/products.php");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response and return it
      return json.decode(response.body);
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Show error message if request failed
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Show message if no data is found
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available.'));
          }

          var products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];

              // Get the product quantity and stock alert
              int productQuantity = int.tryParse(product['product_quantity'].toString()) ?? 0;
              int stockAlert = int.tryParse(product['product_stock_alert'].toString()) ?? 0;

              // Check if product has low stock (quantity <= stock alert)
              bool isLowStock = productQuantity <= stockAlert;

              // Get the image URL (adjust path if needed)
              String imageUrl = product['product_image'] != null
                  ? 'http://192.168.1.4/smartstock_app/storage/app/public/${product['product_image']}'
                  : ''; // Default image path, adjust as necessary

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  title: Text(
                    product['product_name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 60, color: Colors.grey), // Fallback icon if no image
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      // Display product details
                      Text('Quantity: ${product['product_quantity']}'),
                      Text('Cost: ₱${product['product_cost']}'),
                      Text('Price: ₱${product['product_price']}'),
                      Text('Created At: ${product['created_at']}'),
                      Text('Updated At: ${product['updated_at']}'),
                      // Display category name
                      Text('Category: ${product['category_name']}'),
                      // Display low stock alert if applicable
                      if (isLowStock)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Low Stock Alert!',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
