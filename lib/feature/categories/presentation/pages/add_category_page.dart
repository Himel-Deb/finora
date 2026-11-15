
import 'package:flutter/material.dart';

import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/categories/data/repositories.dart/category_repository_impl.dart';

class AddCategoryPage extends StatefulWidget {
  final CategoryModel? category;

  const AddCategoryPage({super.key, this.category});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _nameController = TextEditingController();
  final _repository = CategoryRepositoryImpl();

  final List<String> _icons = [
    'restaurant',
    'directions_bus',
    'shopping_bag',
    'receipt',
    'account_balance_wallet',
    'business',
    'category',
    'medical_services',
    'school',
    'home',
  ];

  String _selectedIcon = 'category';
  bool _isIncome = false;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedIcon = widget.category!.icon;
      _isIncome = widget.category!.isIncome;
    }
  }

 Future<void> _saveCategory() async {
  final name = _nameController.text.trim();

  if (name.isEmpty) return;

  final category = CategoryModel(
    id: widget.category?.id ??
        DateTime.now().millisecondsSinceEpoch.toString(),
    name: name,
    icon: _selectedIcon,
    isIncome: _isIncome,
  );

  await _repository.addCategory(category);

  if (!mounted) return;

  Navigator.pop(context, true);
}
  IconData _getIcon(String icon) {
    switch (icon) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'receipt':
        return Icons.receipt;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'business':
        return Icons.business;
      case 'medical_services':
        return Icons.medical_services;
      case 'school':
        return Icons.school;
      case 'home':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Category' : 'Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category Name'),
            const SizedBox(height: 8),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter category name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text('Category Type'),
            const SizedBox(height: 8),

            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_isIncome},
              onSelectionChanged: (value) {
                setState(() {
                  _isIncome = value.first;
                });
              },
            ),

            const SizedBox(height: 24),

            const Text('Select Icon'),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _icons.map((icon) {
                return ChoiceChip(
                  label: Icon(
                    _getIcon(icon),
                    color: _selectedIcon == icon
                        ? Colors.white
                        : Colors.black,
                  ),
                  selected: _selectedIcon == icon,
                  onSelected: (_) {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCategory,
                child: Text(
                  isEditing ? 'Update Category' : 'Save Category',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
