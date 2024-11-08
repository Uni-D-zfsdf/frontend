import 'package:flutter/material.dart';
import 'package:frontend/const/app_color.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: AppColors.strokeColor);
  }
}
