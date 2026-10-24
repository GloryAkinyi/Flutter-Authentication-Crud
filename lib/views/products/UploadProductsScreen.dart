import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ViewProductsScreen.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() =>
      _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final productName = TextEditingController();
  final category = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();

  bool isLoading = false;

  Future<void> uploadProduct() async {
    if (productName.text.trim().isEmpty ||
        category.text.trim().isEmpty ||
        price.text.trim().isEmpty ||
        quantity.text.trim().isEmpty ||
        description.text.trim().isEmpty ||
        location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final productPrice = double.tryParse(price.text.trim());
    final productQuantity = int.tryParse(quantity.text.trim());

    if (productPrice == null ||
        productPrice <= 0 ||
        productQuantity == null ||
        productQuantity < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid price and quantity'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseDatabase.instance.ref('products').push().set({
        'name': productName.text.trim(),
        'category': category.text.trim(),
        'price': productPrice,
        'quantity': productQuantity,
        'description': description.text.trim(),
        'location': location.text.trim(),
        'createdAt': ServerValue.timestamp,
      });

      if (!mounted) return;

      // Clear the form after a successful upload.
      productName.clear();
      category.clear();
      price.clear();
      quantity.clear();
      description.clear();
      location.clear();

      // Navigate to ViewProductsScreen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewProductsScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    productName.dispose();
    category.dispose();
    price.dispose();
    quantity.dispose();
    description.dispose();
    location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Upload Product'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.add_shopping_cart,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 15),
            const Text(
              'Add Your Product',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter the details of the product you want to sell.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: productName,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'e.g. Samsung Phone',
                prefixIcon: Icon(Icons.shopping_bag),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: category,
              decoration: const InputDecoration(
                labelText: 'Product Category',
                hintText: 'e.g. Electronics',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: price,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Price (KSh)',
                hintText: 'Enter product price',
                prefixIcon: Icon(Icons.money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: quantity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity Available',
                hintText: 'Enter quantity',
                prefixIcon: Icon(Icons.inventory),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: description,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Product Description',
                hintText: 'Describe your product...',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: location,
              decoration: const InputDecoration(
                labelText: 'Seller Location',
                hintText: 'e.g. Nairobi, Kenya',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isLoading ? null : uploadProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                'Upload Product',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
