// lib/add_car_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  int _currentStep = 1; // Step 1: Add car info, Step 2: Add car documents
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();

  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedYear;

  final List<String> _brands = ['Toyota', 'Honda', 'Lexus', 'Nissan', 'Mercedes-Benz', 'BMW'];
  final List<String> _models = ['Corolla', 'Camry', 'Accord', 'Civic', 'RX 350', 'ES 350'];
  final List<String> _years = List.generate(30, (index) => (2024 - index).toString());

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
        title: Text('Add Car', style: kHeading1.copyWith(fontSize: 20)),
      ),
      body: _currentStep == 1 ? _buildStep1() : _buildStep2(),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          // Step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '1. Add car info',
                style: kBodyText.copyWith(
                  color: _currentStep == 1 ? kPrimaryColor : kSubtextGray,
                  fontWeight: _currentStep == 1 ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: kBodyText.copyWith(color: kSubtextGray),
              ),
              const SizedBox(width: 8),
              Text(
                '2. Add car documents',
                style: kBodyText.copyWith(
                  color: _currentStep == 2 ? kPrimaryColor : kSubtextGray,
                  fontWeight: _currentStep == 2 ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildDropdownField(
            label: 'Brand',
            hint: 'Select car brand',
            value: _selectedBrand,
            items: _brands,
            onChanged: (value) {
              setState(() {
                _selectedBrand = value;
                _selectedModel = null; // Reset model when brand changes
              });
            },
          ),
          const SizedBox(height: 20),
          _buildDropdownField(
            label: 'Model',
            hint: 'Select car model',
            value: _selectedModel,
            items: _models,
            onChanged: (value) {
              setState(() {
                _selectedModel = value;
              });
            },
            enabled: _selectedBrand != null,
          ),
          const SizedBox(height: 20),
          _buildDropdownField(
            label: 'Year',
            hint: 'What year is the car?',
            value: _selectedYear,
            items: _years,
            onChanged: (value) {
              setState(() {
                _selectedYear = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            'License plate number',
            style: kBodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _licensePlateController,
            decoration: InputDecoration(
              hintText: 'Enter license plate',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kPrimaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'VIN (Vehicle identification number)',
            style: kBodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _vinController,
            decoration: InputDecoration(
              hintText: 'Enter vehicle identification number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kPrimaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedBrand != null && _selectedModel != null && _selectedYear != null) {
                  setState(() {
                    _currentStep = 2;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Next', style: kButtonText.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text(
            'Upload Car Documents',
            style: kHeading2,
          ),
          const SizedBox(height: 30),
          _buildDocumentUploadCard('Vehicle Registration Certificate'),
          const SizedBox(height: 20),
          _buildDocumentUploadCard('Insurance Certificate'),
          const SizedBox(height: 20),
          _buildDocumentUploadCard('Road Worthiness Certificate'),
          const SizedBox(height: 40),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Car added successfully!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Save', style: kButtonText.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: kBodyText.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: kBodyText),
              );
            }).toList(),
            onChanged: enabled ? onChanged : null,
            style: kBodyText,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadCard(String title) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Handle document upload
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: kLightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.upload_file, color: kPrimaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: kBodyText.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to upload',
                      style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kSubtextGray),
            ],
          ),
        ),
      ),
    );
  }
}

