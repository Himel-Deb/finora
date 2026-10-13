
import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class WidgetTestPage extends StatefulWidget {
  const WidgetTestPage({super.key});

  @override
  State<WidgetTestPage> createState() => _WidgetTestPageState();
}

class _WidgetTestPageState extends State<WidgetTestPage> {
  final TextEditingController _nameController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingMd),
        child: Column(
          children: [
            AppTextField(
              controller: _nameController,
              label: AppStrings.nameLabel,
              hint: AppStrings.nameHint,
            ),
            const SizedBox(height: AppSizes.spacingLg),
            PrimaryButton(
              text: AppStrings.getStarted,
              onPressed: () {
                debugPrint(_nameController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
