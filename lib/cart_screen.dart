// lib/cart_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'order_history_screen.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Mock cart items - in real app, this would come from a state management solution
  List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'Front Brake Pads (Bosch Premium)',
      imageUrl: 'https://placehold.co/80x80/3A7BD5/FFFFFF?text=BP',
      price: 18500.0,
      quantity: 1,
    ),
    CartItem(
      id: '2',
      name: 'Car Battery (Solite 75AH)',
      imageUrl: 'https://placehold.co/80x80/1E3A8A/FFFFFF?text=CB',
      price: 78430.0,
      quantity: 1,
    ),
  ];

  bool get _isCartEmpty => _cartItems.isEmpty;

  double get _subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.total);
  double get _deliveryFee => 2000.0;
  double get _discount => 0.0;
  double get _total => _subtotal + _deliveryFee - _discount;

  void _updateQuantity(CartItem item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity <= 0) {
        _cartItems.remove(item);
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
  }

  void _confirmOrder() {
    if (_cartItems.isEmpty) return;
    
    // Navigate to order history or show success message
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OrderHistoryScreen(),
      ),
    );
    
    // Clear cart after order confirmation
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button when accessed from bottom nav
        title: Text('Order Cart', style: kHeading1.copyWith(fontSize: 20)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kTextColor),
            onPressed: () {
              // Navigate to order history
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isCartEmpty ? _buildEmptyCart() : _buildActiveCart(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty cart illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: kLightGray,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: kSubtextGray,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Your cart is currently empty',
            style: kHeading1.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Start shopping to add items to your cart.',
            style: kBodyText.copyWith(color: kSubtextGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCart() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Items
                ..._cartItems.map((item) => _buildCartItem(item)).toList(),
                const SizedBox(height: 24),
                
                // Order Summary
                Text('Order Summary', style: kHeading2.copyWith(fontSize: 18)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kLightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', 'N${_subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Delivery Fee', 'N${_deliveryFee.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Discount', 'N${_discount.toStringAsFixed(0)}'),
                      const Divider(height: 24, color: Color(0xFFE5E7EB)),
                      _buildSummaryRow('Total', 'N${_total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        // Confirm Order Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _confirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Confirm Order', style: kButtonText),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kLightGray,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  color: kSubtextGray,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: kBodyText.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'N${item.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: kHeading2.copyWith(fontSize: 16, color: kDeepBlue),
                ),
                const SizedBox(height: 12),
                // Quantity Controls
                Row(
                  children: [
                    _buildQuantityButton(Icons.remove, () => _updateQuantity(item, -1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '${item.quantity}',
                        style: kBodyText.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    _buildQuantityButton(Icons.add, () => _updateQuantity(item, 1)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: kPrimaryColor),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: kBodyText.copyWith(
            color: isTotal ? kTextColor : kSubtextGray,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: kBodyText.copyWith(
            color: isTotal ? kDeepBlue : kTextColor,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }
}