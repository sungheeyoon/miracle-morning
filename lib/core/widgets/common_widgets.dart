import 'package:flutter/material.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/core/theme/app_text_styles.dart';

/// 앱 전체에서 공통으로 사용되는 위젯들을 정의
/// 일관된 디자인 시스템을 유지하는데 도움이 됩니다.

// 섹션 헤더 위젯
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: AppTextStyles.subtitle1,
              ),
            ],
          ),
          if (onTap != null)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.grey600,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 앱 기본 카드 위젯
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final Border? border;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.borderRadius = 12,
    this.onTap,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.cardBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: elevation != null && elevation! > 0
              ? [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: elevation! * 4,
                    spreadRadius: elevation! * 0.5,
                    offset: Offset(0, elevation! * 0.5),
                  ),
                ]
              : null,
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// 앱 기본 버튼 위젯
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? textColor;
  final Size? minimumSize;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.icon,
    this.textColor,
    this.minimumSize,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? (isOutlined ? Colors.transparent : AppColors.primary);
    final txtColor = textColor ?? (isOutlined ? AppColors.primary : AppColors.white);

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: txtColor,
        minimumSize: minimumSize ?? const Size(double.infinity, 48),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          side: isOutlined
              ? const BorderSide(color: AppColors.primary, width: 1.5)
              : BorderSide.none,
        ),
        elevation: isOutlined ? 0 : 2,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.button.copyWith(
                    color: txtColor,
                  ),
                ),
              ],
            ),
    );
  }
}

// 그라데이션 버튼 위젯
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final bool isLoading;
  final IconData? icon;
  final double? borderRadius;
  final EdgeInsets? padding;

  const GradientButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.gradientColors = const [AppColors.primaryLight, AppColors.primary],
    this.isLoading = false,
    this.icon,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.white,
          shadowColor: Colors.transparent,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}

// 앱 텍스트 필드 위젯
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final bool enabled;

  const AppTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.autofocus = false,
    this.textInputAction,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: textInputAction,
      enabled: enabled,
      style: AppTextStyles.body1,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.grey500) : null,
        suffixIcon: suffixIcon,
        labelStyle: AppTextStyles.body2.copyWith(color: AppColors.grey600),
      ),
    );
  }
}

// 빈 상태 위젯 (데이터가 없을 때 표시)
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.onActionPressed,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor ?? AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.subtitle1,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle!,
                style: AppTextStyles.body2.copyWith(color: AppColors.grey600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (onActionPressed != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            AppButton(
              label: actionLabel!,
              onPressed: onActionPressed!,
              minimumSize: const Size(200, 48),
            ),
          ],
        ],
      ),
    );
  }
}

// 날짜 관련 위젯
class DateDisplayWidget extends StatelessWidget {
  final DateTime date;
  final TextStyle? style;
  final bool showIcon;
  final bool showWeekday;
  final bool fullFormat;

  const DateDisplayWidget({
    Key? key,
    required this.date,
    this.style,
    this.showIcon = true,
    this.showWeekday = false,
    this.fullFormat = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    final bool isToday = dateOnly == today;
    final bool isTomorrow = dateOnly == today.add(const Duration(days: 1));
    final bool isYesterday = dateOnly == today.subtract(const Duration(days: 1));
    
    String displayText;
    
    if (isToday) {
      displayText = '오늘';
    } else if (isTomorrow) {
      displayText = '내일';
    } else if (isYesterday) {
      displayText = '어제';
    } else if (fullFormat) {
      displayText = '${date.year}년 ${date.month}월 ${date.day}일';
    } else {
      displayText = '${date.month}월 ${date.day}일';
    }
    
    if (showWeekday) {
      final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      // 0 = 월요일, ..., 6 = 일요일로 변환
      final weekdayIndex = (date.weekday - 1) % 7; 
      displayText += ' (${weekdays[weekdayIndex]})';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: (style?.color ?? AppColors.grey600),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          displayText,
          style: style ?? AppTextStyles.body2.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }
}
