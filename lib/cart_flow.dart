import 'package:flutter/material.dart';

// --- 1. Design Constants (Based on Ladipo App Branding) ---
// Color Palette
const Color kPrimaryColor = Color(0xFF3A7BD5); // Light Blue Primary
const Color kDeepBlue = Color(0xFF1E3A8A); // Deep Blue Secondary (for AppBar/Header accents)
const Color kBackgroundColor = Color(0xFFFFFFFF); // White background
const Color kLightGray = Color(0xFFF5F6FA); // Soft gray for background elements
const Color kTextColor = Color(0xFF111827); // Dark Text
const Color kSubtextGray = Color(0xFF6B7280); // Subtext Gray
const Color kAccentYellow = Color(0xFFFACC15);
const Color kSuccessGreen = Color(0xFF22C55E);

// Typography (Assuming Inter font is available)
const TextStyle kHeading1 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 24, color: kTextColor);
const TextStyle kHeading2 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18, color: kTextColor);
const TextStyle kBodyText = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 14, color: kTextColor);
const TextStyle kButtonText = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white);

// --- 2. Mock Data Models ---
class CartItem {
  final String id;
  final String name;
  final String vendor;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({required this.id, required this.name, required this.vendor, required this.price, required this.imageUrl, this.quantity = 1});

  double get total => price * quantity;
}

class Order {
  final String id;
  final String name;
  final double price;
  final String status;
  final String date;
  final String imageUrl;
  final String orderReference;

  Order({required this.id, required this.name, required this.price, required this.status, required this.date, required this.imageUrl, required this.orderReference});
}

// --- 3. Main App and State Management ---
enum AppView { activeCart, emptyCart, orderHistory, productDetail, confirmDelivery }

void main() {
  // We wrap the app in DefaultTextStyle to simulate the custom font "Inter" for visual consistency.
  runApp(const MaterialApp(
    home: DefaultTextStyle(
      style: TextStyle(fontFamily: 'Inter'),
      child: CartFlowApp(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class CartFlowApp extends StatefulWidget {
  const CartFlowApp({super.key});

  @override
  State<CartFlowApp> createState() => _CartFlowAppState();
}

class _CartFlowAppState extends State<CartFlowApp> {
  // Initialize with an active cart for the first screen
  AppView _currentView = AppView.activeCart;
  int _bottomNavIndex = 0; // 0: Cart, 1: History (Placeholder)
  List<CartItem> _cartItems = [
    CartItem(id: 'c1', name: 'Front Brake Pads (Bosch) Premium', vendor: 'Bosch', price: 8500.00, imageUrl: 'https://placehold.co/60x60/FACC15/000000?text=BP', quantity: 1),
    CartItem(id: 'c2', name: 'Car Battery (75AH) E-Series', vendor: 'Car Battery Factory (75AH)', price: 94900.00, imageUrl: 'https://placehold.co/60x60/3A7BD5/FFFFFF?text=BT', quantity: 1),
  ];
  final List<Order> _orderHistory = [
    Order(id: 'o1', name: 'Brain Box for Toyota Corolla', price: 120000.00, status: 'Delivered', date: '2025-10-28', imageUrl: 'https://placehold.co/60x60/1E3A8A/FFFFFF?text=BB', orderReference: 'LD-90123'),
    Order(id: 'o2', name: 'Fuel Injector Nozzle', price: 15500.00, status: 'Pending', date: '2025-11-01', imageUrl: 'https://placehold.co/60x60/3A7BD5/FFFFFF?text=FN', orderReference: 'LD-90124'),
  ];

  void _navigateTo(AppView view) {
    setState(() {
      _currentView = view;
      // Ensure bottom nav index is set correctly when navigating
      if (view == AppView.activeCart || view == AppView.emptyCart) {
        _bottomNavIndex = 0;
      } else if (view == AppView.orderHistory) {
        _bottomNavIndex = 1;
      }
    });
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _bottomNavIndex = index;
      if (index == 0) {
        _currentView = _cartItems.isEmpty ? AppView.emptyCart : AppView.activeCart;
      } else if (index == 1) {
        _currentView = AppView.orderHistory;
      }
    });
  }

  // Cart Management Functions for ActiveCartScreen
  void _updateQuantity(CartItem item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity <= 0) {
        _cartItems.remove(item);
      }
      if (_cartItems.isEmpty) {
        _currentView = AppView.emptyCart;
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.remove(item);
      if (_cartItems.isEmpty) {
        _currentView = AppView.emptyCart;
      }
    });
  }

  // Primary screen switch
  Widget _buildCurrentScreen() {
    switch (_currentView) {
      case AppView.activeCart:
        return ActiveCartScreen(
          items: _cartItems,
          onUpdateQuantity: _updateQuantity,
          onRemoveItem: _removeItem,
          onConfirmOrder: () => _navigateTo(AppView.orderHistory),
        );
      case AppView.emptyCart:
        return const EmptyCartScreen();
      case AppView.orderHistory:
        return OrderHistoryScreen(
          orders: _orderHistory,
          onViewDetails: (order) => _navigateTo(AppView.productDetail),
        );
      case AppView.productDetail:
        return ProductDetailScreen(
          onConfirmDelivery: () => _navigateTo(AppView.confirmDelivery),
          onBack: () => _navigateTo(AppView.orderHistory),
        );
      case AppView.confirmDelivery:
        return ConfirmDeliveryScreen(
          onDone: () => _navigateTo(AppView.orderHistory),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the title based on the current view
    String title;
    bool showBackButton = false;
    if (_currentView == AppView.activeCart || _currentView == AppView.emptyCart) {
      title = 'Order Cart';
    } else if (_currentView == AppView.orderHistory) {
      title = 'Order History';
    } else {
      title = 'Order Details';
      showBackButton = true;
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _currentView != AppView.confirmDelivery
          ? AppBar(
              backgroundColor: kBackgroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(title, style: kHeading2.copyWith(fontSize: 20)),
              centerTitle: false,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: kTextColor),
                      onPressed: () {
                        // Handle back navigation for detailed screens
                        if (_currentView == AppView.productDetail) {
                          _navigateTo(AppView.orderHistory);
                        }
                      },
                    )
                  : null,
              actions: [
                if (_currentView == AppView.activeCart || _currentView == AppView.orderHistory)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.shopping_bag_outlined, color: kTextColor),
                  ),
              ],
            )
          : null, // No AppBar for success screen
      body: _buildCurrentScreen(),
      bottomNavigationBar: _currentView != AppView.confirmDelivery
          ? AppBottomNavBar(
              currentIndex: _bottomNavIndex,
              onTap: _handleBottomNavTap,
            )
          : null, // No bottom nav for success screen
    );
  }
}

// --- 4. Screen Implementations ---

// 1. Active Cart Screen
class ActiveCartScreen extends StatelessWidget {
  final List<CartItem> items;
  final Function(CartItem, int) onUpdateQuantity;
  final Function(CartItem) onRemoveItem;
  final VoidCallback onConfirmOrder;

  const ActiveCartScreen({
    super.key,
    required this.items,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onConfirmOrder,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get deliveryFee => 1500.00;
  double get total => subtotal + deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Items Section
                Text('Active Cart', style: kHeading2.copyWith(fontSize: 18, color: kSubtextGray)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kLightGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: items.map((item) => _buildCartItem(context, item)).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Order Summary Section
                Text('Order Summary', style: kHeading2.copyWith(fontSize: 18, color: kSubtextGray)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kLightGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', '₦${subtotal.toStringAsFixed(2)}', isTotal: false),
                      _buildSummaryRow('Delivery Fee', '₦${deliveryFee.toStringAsFixed(2)}', isTotal: false),
                      const Divider(height: 24, color: Color(0xFFE5E7EB)),
                      _buildSummaryRow('Total Amount', '₦${total.toStringAsFixed(2)}', isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        // Action Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
              ),
              child: Text('Confirm Order', style: kButtonText),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: kBodyText.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.vendor,
                      style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₦${item.price.toStringAsFixed(2)}',
                      style: kBodyText.copyWith(fontWeight: FontWeight.w700, color: kDeepBlue),
                    ),
                  ],
                ),
              ),
              // Quantity Selector and Remove
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      _buildQuantityButton(Icons.remove, () => onUpdateQuantity(item, -1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('${item.quantity}', style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
                      ),
                      _buildQuantityButton(Icons.add, () => onUpdateQuantity(item, 1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => onRemoveItem(item),
                    child: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]),
                  ),
                ],
              ),
            ],
          ),
          if (items.indexOf(item) < items.length - 1)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Divider(color: Color(0xFFE5E7EB), height: 1),
            ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: kPrimaryColor),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {required bool isTotal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kBodyText.copyWith(
              color: isTotal ? kTextColor : kSubtextGray,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Text(
            amount,
            style: kHeading2.copyWith(
              fontSize: 16,
              color: isTotal ? kDeepBlue : kTextColor,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Empty Cart Screen
class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty Cart Illustration Placeholder
          Icon(Icons.shopping_cart_outlined, size: 100, color: kPrimaryColor.withOpacity(0.5)),
          const SizedBox(height: 24),
          Text(
            'Your cart is currently empty.',
            style: kHeading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Browse items to add them to your cart.',
            style: kBodyText.copyWith(color: kSubtextGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// 3. Order History Screen
class OrderHistoryScreen extends StatelessWidget {
  final List<Order> orders;
  final Function(Order) onViewDetails;

  const OrderHistoryScreen({super.key, required this.orders, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: orders.map((order) => _buildOrderItem(context, order)).toList(),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Order order) {
    Color statusColor;
    if (order.status == 'Delivered') {
      statusColor = kSuccessGreen;
    } else if (order.status == 'Pending') {
      statusColor = kAccentYellow;
    } else {
      statusColor = Colors.red;
    }

    return GestureDetector(
      onTap: () => onViewDetails(order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kLightGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(order.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: kBodyText.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '₦${order.price.toStringAsFixed(2)}',
                    style: kHeading2.copyWith(fontSize: 16, color: kDeepBlue),
                  ),
                ],
              ),
            ),
            // Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    order.status,
                    style: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.date,
                  style: kBodyText.copyWith(fontSize: 11, color: kSubtextGray),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // More options icon
            const Icon(Icons.chevron_right, color: kSubtextGray, size: 20),
          ],
        ),
      ),
    );
  }
}

// 4. Product Detail & Vendor Interaction Screen
class ProductDetailScreen extends StatelessWidget {
  final VoidCallback onConfirmDelivery;
  final VoidCallback onBack;

  const ProductDetailScreen({super.key, required this.onConfirmDelivery, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Product Image Banner
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              // Using a placehold image to simulate the high-quality automotive part image
              image: NetworkImage('https://placehold.co/600x200/111827/FFFFFF?text=ENGINE+PART+IMAGE'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Details Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kLightGray,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Brain Box for Toyota Corolla', style: kHeading2.copyWith(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text('₦120,000.00', style: kHeading1.copyWith(color: kDeepBlue, fontSize: 24)),
                      const Divider(height: 30, color: Color(0xFFE5E7EB)),
                      Text('Vendor Information', style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      _buildVendorInfo(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Product Description Placeholder
                Text('Product Description', style: kHeading2.copyWith(fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  'Original Brain Box (ECU) for Toyota Corolla 2008-2014 models. Tested and verified for optimal performance. Comes with a 90-day warranty. Contact vendor for compatibility confirmation.',
                  style: kBodyText.copyWith(color: kSubtextGray),
                ),
              ],
            ),
          ),
        ),
        // Vendor Action Buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kBackgroundColor,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
                  label: Text('Report Issue', style: kButtonText.copyWith(color: Colors.redAccent, fontSize: 14)),
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
                  onPressed: onConfirmDelivery,
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text('Confirm Delivery', style: kButtonText.copyWith(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSuccessGreen,
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
    );
  }

  Widget _buildVendorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: kPrimaryColor.withOpacity(0.1),
          backgroundImage: const NetworkImage('https://placehold.co/100x100/3A7BD5/FFFFFF?text=TA'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tunde Abraham', style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
            Row(
              children: [
                const Icon(Icons.star, color: kAccentYellow, size: 14),
                Text(' 4.7 ', style: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(' | Ikeja, Lagos', style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray)),
              ],
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.chat_bubble_outline, color: kPrimaryColor),
        )
      ],
    );
  }
}

// 5. Confirm Delivery Screen
class ConfirmDeliveryScreen extends StatelessWidget {
  final VoidCallback onDone;

  const ConfirmDeliveryScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kSuccessGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, size: 100, color: kSuccessGreen),
          ),
          const SizedBox(height: 32),
          Text(
            'Your delivery has been confirmed.',
            style: kHeading1.copyWith(color: kSuccessGreen),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Thank you for shopping with Ladipo. You can now review this delivery in your order history.',
              style: kBodyText.copyWith(color: kSubtextGray),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                ),
                child: Text('Go to Order History', style: kButtonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 6. Shared Navigation Widget ---

// Widget for the persistent bottom navigation bar (Simulated)
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            activeIcon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          // Placeholder items from original shared_widgets for consistent layout
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_outlined),
            activeIcon: Icon(Icons.car_rental),
            label: 'My Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}