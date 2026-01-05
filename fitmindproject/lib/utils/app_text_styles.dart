import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Custom font family (Phase 2.2 requirement)
  static const String fontFamily = 'Poppins';

  // Title - 18px/24px, Bold
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  // Subtitle - 14px/20px, SemiBold
  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  // Body - 12px/18px, Regular
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  // Caption - 10px/14px, Regular
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 14 / 10,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Large title for splash/welcome
  static const TextStyle largeTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  // Form label
  static const TextStyle formLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );

  // Error text
  static const TextStyle error = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );
}
