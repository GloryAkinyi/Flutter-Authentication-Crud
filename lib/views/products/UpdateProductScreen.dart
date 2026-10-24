
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UpdateProductScreen extends StatefulWidget {
  final String? productId;
  final Map<dynamic, dynamic>? product;

  const UpdateProductScreen({super.key, this.productId, this.product});

  @override
  State<UpdateProductScreen> createState() =>
      _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final DatabaseReference productsRef =
  FirebaseDatabase.instance.ref('products');

  String? selectedId;
  final name = TextEditingController();
  final category = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null && widget.product != null) {
      selectedId = widget.productId;
      name.text = widget.product!['name']?.toString() ?? '';
      category.text = widget.product!['category']?.toString() ?? '';
      price.text = widget.product!['price']?.toString() ?? '';
      quantity.text = widget.product!['quantity']?.toString() ?? '';
      description.text = widget.product!['description']?.toString() ?? '';
      location.text = widget.product!['location']?.toString() ?? '';
    }
  }

  void selectProduct(String id, Map<dynamic, dynamic> product) {
    setState(() {
      selectedId = id;
      name.text = product['name']?.toString() ?? '';
      category.text = product['category']?.toString() ?? '';
      price.text = product['price']?.toString() ?? '';
      quantity.text = product['quantity']?.toString() ?? '';
      description.text = product['description']?.toString() ?? '';
      location.text = product['location']?.toString() ?? '';
    });
  }

  Future<void> updateProduct() async {
    if (selectedId == null) {
      showMessage('Please select a product first.');
      return;
    }

    if (name.text.trim().isEmpty ||
        category.text.trim().isEmpty ||
        price.text.trim().isEmpty ||
        quantity.text.trim().isEmpty ||
        description.text.trim().isEmpty ||
        location.text.trim().isEmpty) {
      showMessage('Please fill in all fields.');
      return;
    }

    final productPrice = double.tryParse(price.text.trim());
    final productQuantity = int.tryParse(quantity.text.trim());

    if (productPrice == null ||
        productPrice <= 0 ||
        productQuantity == null ||
        productQuantity < 0) {
      showMessage('Enter a valid price and quantity.');
      return;
    }

    setState(() => isLoading = true);

    try {
      await productsRef.child(selectedId!).update({
        'name': name.text.trim(),
        'category': category.text.trim(),
        'price': productPrice,
        'quantity': productQuantity,
        'description': description.text.trim(),
        'location': location.text.trim(),
      });

      if (!mounted) return;

      showMessage('Product updated successfully!');
    } catch (e) {
      if (!mounted) return;
      showMessage('Update failed: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    name.dispose();
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
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Update Product'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: productsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load products.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data?.snapshot.value;

          if (data == null) {
            return const Center(
              child: Text('No products available to update.'),
            );
          }

          final products = Map<dynamic, dynamic>.from(data as Map);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                '1. Select a product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ...products.entries.map((entry) {
                final id = entry.key.toString();
                final product =
                Map<dynamic, dynamic>.from(entry.value as Map);

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                    title: Text(
                      product['name']?.toString() ?? 'Unnamed Product',
                    ),
                    subtitle: Text(
                      'KSh ${product['price'] ?? 0}',
                    ),
                    trailing: Icon(
                      selectedId == id
                          ? Icons.check_circle
                          : Icons.edit,
                      color: selectedId == id
                          ? Colors.green
                          : Colors.grey,
                    ),
                    selected: selectedId == id,
                    onTap: () => selectProduct(id, product),
                  ),
                );
              }),

              if (selectedId != null) ...[
                const SizedBox(height: 24),
                const Text(
                  '2. Edit product details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: category,
                  decoration: const InputDecoration(
                    labelText: 'Product Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Price (KSh)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: quantity,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity Available',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    labelText: 'Seller Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: isLoading ? null : updateProduct,
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
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
