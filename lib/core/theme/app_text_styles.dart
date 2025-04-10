import 'package:flutter/material.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';

/// 앱 전체에서 사용되는 텍스트 스타일
/// 모든 텍스트 스타일을 한 곳에서 관리하여 일관된 디자인 유지
class AppTextStyles {
  // 기본 폰트 패밀리
  static const String fontFamily = 'Pretendard'; // 앱에서 사용할 폰트 (pubspec.yaml에 등록 필요)
  
  // 제목 스타일
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
    height: 1.3,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
    height: 1.3,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
    height: 1.3,
  );
  
  // 부제목 스타일
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.grey800,
    height: 1.3,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.grey800,
    height: 1.3,
  );
  
  // 본문 스타일
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.grey700,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.grey700,
    height: 1.5,
  );
  
  // 기타 스타일
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.0,
    letterSpacing: 0.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey600,
    height: 1.5,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.grey500,
    height: 1.5,
    letterSpacing: 0.5,
  );
  
  // 메인 숫자 표시용 (통계, 카운터 등)
  static const TextStyle numberLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
  );
  
  static const TextStyle numberMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
  );
  
  // 강조 텍스트
  static const TextStyle emphasis = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.5,
  );
}
