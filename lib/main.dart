import 'package:finora/feature/budgets/data/models/budget_model.dart';
import 'package:finora/feature/categories/data/default_categories.dart';
import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/wallet/data/default_wallet.dart';
import 'package:finora/feature/wallet/data/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:finora/app/app.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(WalletModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());

  await DefaultWallets.initialize();
  await DefaultCategories.initialize();

  runApp(const PaylanceApp());
}