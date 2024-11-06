import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laundry_pos/providers/transaction_provider.dart';

class WeightBasedTransactionScreen extends StatefulWidget {
  @override
  _WeightBasedTransactionScreenState createState() => _WeightBasedTransactionScreenState();
}

class _WeightBasedTransactionScreenState extends State<WeightBasedTransactionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _serviceType;
  String? _subServiceType;
  String? _location;
  double totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    // Add listener to weight controller
    _weightController.addListener(_calculateCost);
  }

  @override
  void dispose() {
    _weightController.removeListener(_calculateCost);
    _weightController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _calculateCost() {
    double weight = double.tryParse(_weightController.text) ?? 0;

    // Reset total cost before each calculation
    totalCost = 0.0;

    if (_serviceType == 'Self Service') {
      if (_subServiceType == 'Full') {
        totalCost = ((weight / 8).ceil()) * 120; // 120 per load, rounded up by 8kg
      } else if (_subServiceType == 'Wash Only' || _subServiceType == 'Dry Only') {
        totalCost = ((weight / 8).ceil()) * 60; // 60 per load, rounded up by 8kg
      }
    } else if (_serviceType == 'Drop-Off') {
      // Set the rate based on the service level
      double rate = _subServiceType == 'Basic Service' ? 25 : 30;

      // Calculate cost by breaking weight into 8kg loads, with each load having a minimum of 5kg if partial
      while (weight > 0) {
        double loadWeight;

        if (weight > 8) {
          loadWeight = 8; // Full 8 kg load
        } else {
          loadWeight = weight < 5 ? 5 : weight; // Minimum 5 kg for partial loads
        }

        totalCost += loadWeight * rate;
        weight -= loadWeight;
      }
    } else if (_serviceType == 'Delivery') {
      // Set the rate based on location and service level
      double rate = 0.0;
      if (_location == 'Within Fortune Towne') {
        rate = _subServiceType == 'Basic Service' ? 30 : 35;
      } else if (_location == 'Outside Fortune Towne') {
        rate = _subServiceType == 'Basic Service' ? 35 : 40;
      }

      // If weight is less than 10 kg but less than or equal to 8 kg, charge for 300 PHP
      if (weight <= 8) {
        totalCost = rate * 10; // Fixed cost for <= 8 kg
      } else {
        // Ensure minimum weight is 10 kg for the first transaction
        weight = weight < 10 ? 10 : weight; // Charge for 10 kg if weight is below 10 kg

        // Calculate cost by breaking weight into 8kg loads, ensuring at least 5 kg for partial loads
        while (weight > 0) {
          double loadWeight;

          if (weight > 8) {
            loadWeight = 8; // Full 8 kg load
          } else {
            loadWeight = weight < 5 ? 5 : weight; // Minimum 5 kg for partial loads
          }

          totalCost += loadWeight * rate;
          weight -= loadWeight;
        }
      }
    }

    setState(() {}); // Refresh the UI with the updated cost
  }



  void _submit() {
    String customerName = _nameController.text;

    if (customerName.isEmpty || _serviceType == null || totalCost == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    String details = 'Weight: ${_weightController.text} kg, '
        'Service: $_serviceType ${_subServiceType != null ? ", $_subServiceType" : ""}'
        '${_location != null ? ", $_location" : ""}';

    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(customerName, 'Weight-Based', details, totalCost);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction added')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight-Based Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              hint: Text('Select Service Type'),
              value: _serviceType,
              items: ['Self Service', 'Drop-Off', 'Delivery']
                  .map((service) => DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _serviceType = value;
                  _subServiceType = null;
                  _location = null;
                  totalCost = 0.0;
                });
              },
            ),
            if (_serviceType == 'Self Service') ...[
              DropdownButton<String>(
                hint: Text('Choose Service Detail'),
                value: _subServiceType,
                items: ['Full', 'Wash Only', 'Dry Only']
                    .map((service) => DropdownMenuItem<String>(
                          value: service,
                          child: Text(service),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _subServiceType = value;
                    _calculateCost();
                  });
                },
              ),
            ],
            if (_serviceType == 'Drop-Off') ...[
              DropdownButton<String>(
                hint: Text('Choose Service Detail'),
                value: _subServiceType,
                items: ['Basic Service', 'Extra Care Service']
                    .map((service) => DropdownMenuItem<String>(
                          value: service,
                          child: Text(service),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _subServiceType = value;
                    _calculateCost();
                  });
                },
              ),
            ],
            if (_serviceType == 'Delivery') ...[
              DropdownButton<String>(
                hint: Text('Location'),
                value: _location,
                items: ['Within Fortune Towne', 'Outside Fortune Towne']
                    .map((location) => DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _location = value;
                    _subServiceType = null;
                  });
                },
              ),
              if (_location != null)
                DropdownButton<String>(
                  hint: Text('Choose Service Detail'),
                  value: _subServiceType,
                  items: ['Basic Service', 'Extra Care Service']
                      .map((service) => DropdownMenuItem<String>(
                            value: service,
                            child: Text(service),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _subServiceType = value;
                      _calculateCost();
                    });
                  },
                ),
            ],
            SizedBox(height: 20),
            Text(
              'Total Cost: ₱${totalCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Proceed Transaction'),
            ),
            ElevatedButton(
              onPressed: () {
                _nameController.clear();
                _weightController.clear();
                setState(() {
                  _serviceType = null;
                  _subServiceType = null;
                  _location = null;
                  totalCost = 0.0;
                });
              },
              child: Text('Cancel Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
