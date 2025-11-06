// lib/order_tracking_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'order_history_screen.dart' show Order;

enum OrderStatus { confirmed, dispatched, delivered }

class OrderTrackingScreen extends StatefulWidget {
  final Order order;

  const OrderTrackingScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  // Mock order status - in real app, this would come from backend
  OrderStatus _currentStatus = OrderStatus.confirmed;

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
        title: Text('Order', style: kHeading1.copyWith(fontSize: 20)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: kTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Product Image
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kLightGray,
            ),
            child: Image.network(
              widget.order.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                size: 80,
                color: kSubtextGray,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Text(
                    widget.order.name,
                    style: kHeading2.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'N${widget.order.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: kHeading1.copyWith(fontSize: 24, color: kDeepBlue),
                  ),
                  const SizedBox(height: 24),
                  
                  // Order Status Timeline
                  _buildStatusTimeline(),
                  const SizedBox(height: 24),
                  
                  // Vendor Information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kLightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vendor Information',
                          style: kBodyText.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        _buildVendorInfo(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle report issue
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report issue feature coming soon')),
                      );
                    },
                    icon: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
                    label: Text(
                      'Report Issue',
                      style: kButtonText.copyWith(color: Colors.redAccent, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_currentStatus == OrderStatus.delivered) {
                        _showDeliveryConfirmed();
                      } else {
                        // Update status for demo purposes
                        setState(() {
                          if (_currentStatus == OrderStatus.confirmed) {
                            _currentStatus = OrderStatus.dispatched;
                          } else if (_currentStatus == OrderStatus.dispatched) {
                            _currentStatus = OrderStatus.delivered;
                          }
                        });
                      }
                    },
                    icon: Icon(
                      _currentStatus == OrderStatus.delivered
                          ? Icons.check_circle_outline
                          : Icons.delivery_dining_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      _currentStatus == OrderStatus.delivered
                          ? 'Delivery Confirmed'
                          : 'Confirm Delivery',
                      style: kButtonText.copyWith(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentStatus == OrderStatus.delivered
                          ? kSuccessGreen
                          : kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kLightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatusStep(
            'Order Confirmed',
            _currentStatus.index >= OrderStatus.confirmed.index,
            isCompleted: _currentStatus.index > OrderStatus.confirmed.index,
          ),
          const SizedBox(height: 16),
          _buildStatusStep(
            'Order Dispatched',
            _currentStatus.index >= OrderStatus.dispatched.index,
            isCompleted: _currentStatus.index > OrderStatus.dispatched.index,
          ),
          const SizedBox(height: 16),
          _buildStatusStep(
            'Order Delivered',
            _currentStatus.index >= OrderStatus.delivered.index,
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(String title, bool isActive, {bool isCompleted = false}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (isCompleted ? kSuccessGreen : kPrimaryColor)
                : Colors.grey[300],
          ),
          child: isActive
              ? Icon(
                  isCompleted ? Icons.check : Icons.radio_button_checked,
                  color: Colors.white,
                  size: 20,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: kBodyText.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isActive ? kTextColor : kSubtextGray,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isActive ? (isCompleted ? 'Completed' : 'Pending') : 'Pending',
                style: kBodyText.copyWith(
                  fontSize: 12,
                  color: isActive
                      ? (isCompleted ? kSuccessGreen : kPrimaryColor)
                      : kSubtextGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVendorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: kPrimaryColor.withOpacity(0.1),
          backgroundImage: const NetworkImage('https://placehold.co/100x100/3A7BD5/FFFFFF?text=TA'),
          onBackgroundImageError: (exception, stackTrace) => const Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tunde Abraham',
                style: kBodyText.copyWith(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: kAccentYellow, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '4.7',
                    style: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '| Ikeja, Lagos',
                    style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.phone, color: kPrimaryColor),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.email_outlined, color: kPrimaryColor),
        ),
      ],
    );
  }

  void _showDeliveryConfirmed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DeliveryConfirmedScreen(),
      ),
    );
  }
}

// Delivery Confirmed Screen
class DeliveryConfirmedScreen extends StatelessWidget {
  const DeliveryConfirmedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: kSuccessGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: kSuccessGreen,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your delivery has been confirmed',
                style: kHeading1.copyWith(fontSize: 24, color: kTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You have successfully confirmed the delivery of your order.',
                style: kBodyText.copyWith(color: kSubtextGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Done', style: kButtonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
