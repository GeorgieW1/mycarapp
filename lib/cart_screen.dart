// lib/cart_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart'; // Import shared widgets and constants

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Simulate active/empty cart state
  bool _isCartEmpty = false; // Set to true to see empty cart state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: kLargeTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order History tapped')));
            },
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: _isCartEmpty ? _buildEmptyCart() : _buildActiveCart(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder image or icon for empty cart
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'Your cart is currently empty.',
            style: kLargeTitle.copyWith(fontSize: 20, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add some items to get started!',
            style: kBodyText,
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            text: 'Browse Products',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Browse products tapped')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCart() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: kLargeTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 15),
          _buildCartItem(
            'Premium Synthetic Oil',
            'N18,500',
            'assets/oil_placeholder.png', // Placeholder asset
          ),
          _buildCartItem(
            'Car Battery 75AH',
            'N77,360',
            'assets/battery_placeholder.png', // Placeholder asset
          ),
          const SizedBox(height: 20),
          
          _buildSummaryRow('Subtotal', 'N95,860'),
          _buildSummaryRow('Shipping', 'N2,000'),
          const Divider(),
          _buildSummaryRow('Total', 'N97,860', isTotal: true),
          const SizedBox(height: 30),
          PrimaryButton(
            text: 'Confirm Order',
            onPressed: () {
              // Simulate order confirmation flow
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(String title, String price, String imageAsset) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  // Use a placeholder image or actual asset
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
              child: Image.asset(imageAsset, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey)), // Placeholder if image not found
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(price, style: kBodyText.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Remove $title from cart')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? kLargeTitle.copyWith(fontSize: 18)
                : const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: isTotal
                ? kLargeTitle.copyWith(fontSize: 18, color: kPrimaryColor)
                : const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// Separate screen for order confirmation as shown in Image 4
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed', style: kLargeTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green.withOpacity(0.1),
              child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            ),
            const SizedBox(height: 30),
            Text(
              'Your delivery has been confirmed!',
              style: kLargeTitle.copyWith(fontSize: 22, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you for your purchase.',
              style: kBodyText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: 'Back to Home',
              onPressed: () {
                // Navigate back to the dashboard's home tab
                Navigator.of(context).popUntil((route) => route.isFirst); 
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('View Order Details tapped')));
              },
              child: Text(
                'View Order Details',
                style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
