import 'package:flutter/material.dart';

/// 앱 전체에서 사용되는 색상 팔레트
/// 모든 색상을 한 곳에서 관리하여 일관된 디자인 유지
class AppColors {
  // 기본 색상
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  
  // 주요 색상 
  static const Color primary = Color(0xFF3B82F6); // 파란색 계열
  static const Color primaryLight = Color(0xFF60A5FA); // 더 밝은 파란색
  static const Color primaryDark = Color(0xFF2563EB); // 더 어두운 파란색

  // 보조 색상
  static const Color secondary = Color(0xFF10B981); // 초록색 계열
  static const Color secondaryLight = Color(0xFF34D399); // 더 밝은 초록색
  static const Color secondaryDark = Color(0xFF059669); // 더 어두운 초록색

  // 음영 및 배경
  static const Color background = Color(0xFFFFFFFF); // 기본 배경
  static const Color cardBackground = Color(0xFFF8F9FF); // 카드 배경
  static const Color scaffoldBackground = Color(0xFFF9FAFB); // 스캐폴드 배경
  
  // 그레이 스케일
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);
  
  // 상태 색상
  static const Color success = Color(0xFF10B981); // 성공
  static const Color warning = Color(0xFFF59E0B); // 경고
  static const Color error = Color(0xFFEF4444); // 오류
  static const Color info = Color(0xFF3B82F6); // 정보
  
  // 그라데이션
  static const List<Color> primaryGradient = [
    Color(0xFF60A5FA), // 시작 색상 - 밝은 파란색
    Color(0xFF3B82F6), // 끝 색상 - 파란색
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF34D399), // 시작 색상 - 밝은 초록색
    Color(0xFF10B981), // 끝 색상 - 초록색
  ];
  
  // 그림자 색상
  static Color shadowColor = Colors.black.withOpacity(0.1);
  static Color primaryShadow = primary.withOpacity(0.3);
}
