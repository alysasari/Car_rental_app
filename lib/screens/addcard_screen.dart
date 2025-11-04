
import 'package:flutter/material.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _expCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  void _saveCard() {
    if (!_formKey.currentState!.validate()) return;

    final number = _numberCtrl.text.replaceAll(' ', '');
    final last4 = number.length >= 4 ? number.substring(number.length - 4) : number;
    final brand = _detectBrand(number);

    Navigator.pop(context, {'brand': brand, 'last4': last4});
  }

  String _detectBrand(String num) {
    if (num.startsWith('4')) return 'Visa';
    if (num.startsWith('5')) return 'Mastercard';
    return 'Card';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Card'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numberCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Card Number'),
                validator: (v) => (v == null || v.trim().length < 12) ? 'Invalid number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name on Card')),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextFormField(controller: _expCtrl, decoration: const InputDecoration(labelText: 'MM/YY'))),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: _cvvCtrl, decoration: const InputDecoration(labelText: 'CVV'))),
              ]),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveCard,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B6EF6), minimumSize: const Size(double.infinity, 50)),
                child: const Text('Save Card', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
