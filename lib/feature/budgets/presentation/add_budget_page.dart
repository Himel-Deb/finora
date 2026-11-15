
import 'package:finora/feature/budgets/data/models/budget_model.dart';
import 'package:finora/feature/budgets/data/repositories/budget_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/categories/data/repositories.dart/category_repository_impl.dart';

class AddBudgetPage extends StatefulWidget {
  final BudgetModel? budget;

  const AddBudgetPage({super.key, this.budget});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _amountController = TextEditingController();
  final _budgetRepository = BudgetRepositoryImpl();
  final _categoryRepository = CategoryRepositoryImpl();

  List<CategoryModel> _categories = [];
  String? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.budget != null) {
      _amountController.text =
          (widget.budget!.amountPaisa / 100).toStringAsFixed(2);
    }

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryRepository.getAllCategories();

    if (!mounted) return;

    setState(() {
      _categories = categories
          .where((category) => !category.isIncome)
          .toList();

      _selectedCategoryId = widget.budget?.categoryId ??
          (_categories.isNotEmpty ? _categories.first.id : null);

      _isLoading = false;
    });
  }

  Future<void> _saveBudget() async {
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null ||
        amount <= 0 ||
        _selectedCategoryId == null) {
      return;
    }

    final oldBudget = widget.budget;
    final now = DateTime.now();

    final month = oldBudget?.month ?? now.month;
    final year = oldBudget?.year ?? now.year;

    final budget = BudgetModel(
      id: '${_selectedCategoryId}_${month}_$year',
      categoryId: _selectedCategoryId!,
      amountPaisa: (amount * 100).round(),
      month: month,
      year: year,
    );

    if (oldBudget != null && oldBudget.id != budget.id) {
      await _budgetRepository.deleteBudget(oldBudget.id);
    }

    await _budgetRepository.addBudget(budget);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.budget != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Budget' : 'Add Budget'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Category'),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text('Budget Amount (৳)'),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter budget amount',
                      border: OutlineInputBorder(),
                      prefixText: '৳ ',
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _categories.isEmpty ? null : _saveBudget,
                      child: Text(
                        isEditing ? 'Update Budget' : 'Save Budget',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
