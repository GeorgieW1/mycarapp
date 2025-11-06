// lib/order_history_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'order_tracking_screen.dart';

class Order {
  final String id;
  final String name;
  final double price;
  final String status;
  final String date;
  final String imageUrl;
  final String orderReference;

  Order({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
    required this.date,
    required this.imageUrl,
    required this.orderReference,
  });
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Mock order history data
  final List<Order> _orders = [
    Order(
      id: '1',
      name: 'Brain Box for Toyota Corrola',
      price: 120000.0,
      status: 'Order Confirmed',
      date: '2025-10-28',
      imageUrl: 'https://placehold.co/60x60/1E3A8A/FFFFFF?text=BB',
      orderReference: 'LD-90123',
    ),
    Order(
      id: '2',
      name: 'Car Battery (Solite 75AH)',
      price: 78430.0,
      status: 'Order Confirmed',
      date: '2025-10-29',
      imageUrl: 'https://placehold.co/60x60/3A7BD5/FFFFFF?text=CB',
      orderReference: 'LD-90124',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Order History', style: kHeading1.copyWith(fontSize: 20)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: _orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                return _buildOrderItem(_orders[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: kSubtextGray),
          const SizedBox(height: 20),
          Text(
            'No orders yet',
            style: kHeading1.copyWith(fontSize: 20, color: kSubtextGray),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kLightGray,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  order.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    color: kSubtextGray,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: kBodyText.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'N${order.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: kHeading2.copyWith(fontSize: 16, color: kDeepBlue),
                  ),
                ],
              ),
            ),
            // Status Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: kSuccessGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: kSuccessGreen),
                      const SizedBox(width: 4),
                      Text(
                        order.status,
                        style: kBodyText.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kSuccessGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderTrackingScreen(order: order),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View More',
                    style: kBodyText.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
