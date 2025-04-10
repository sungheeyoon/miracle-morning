# 미라클 모닝 앱 디자인 가이드

## 개요
이 문서는 미라클 모닝 앱의 디자인 시스템에 관한 가이드라인을 제시합니다. 모든 개발자와 디자이너가 일관된 디자인 원칙을 따르도록 하기 위해 작성되었습니다.

## 디자인 시스템 구조

### 1. 폰트 (Pretendard)
앱 전체에서 'Pretendard' 폰트 패밀리를 사용합니다. 이 폰트는 다양한 가중치를 제공하여 다양한 텍스트 스타일을 표현할 수 있습니다.

### 2. 색상 팔레트
모든 색상은 `lib/core/theme/app_colors.dart` 파일에 정의되어 있습니다.

- **기본 색상**
  - Primary: #3B82F6 (파란색 계열)
  - Secondary: #10B981 (초록색 계열)

- **그레이 스케일**
  - Grey50 ~ Grey900: 다양한 단계의 회색 톤

- **상태 색상**
  - Success: #10B981
  - Warning: #F59E0B
  - Error: #EF4444
  - Info: #3B82F6

### 3. 텍스트 스타일
모든 텍스트 스타일은 `lib/core/theme/app_text_styles.dart` 파일에 정의되어 있습니다.

- **제목 스타일**
  - headline1: 28px, Bold
  - headline2: 24px, Bold
  - headline3: 20px, Bold

- **부제목 스타일**
  - subtitle1: 18px, SemiBold
  - subtitle2: 16px, SemiBold

- **본문 스타일**
  - body1: 16px, Regular
  - body2: 14px, Regular

### 4. 공통 위젯
자주 사용되는 UI 요소들은 `lib/core/widgets/common_widgets.dart` 파일에 정의되어 있습니다.

- **섹션 헤더 (SectionHeader)**
  - 섹션 제목과 아이콘을 함께 표시

- **앱 카드 (AppCard)**
  - 정보를 그룹화하는 컨테이너

- **버튼 (AppButton, GradientButton)**
  - 일반 버튼과 그라데이션 버튼

- **텍스트 필드 (AppTextField)**
  - 일관된 스타일의 입력 필드

- **빈 상태 위젯 (EmptyStateWidget)**
  - 데이터가 없을 때 표시하는 상태 화면

## 스크린별 디자인 가이드라인

### 1. 홈 화면
- 캘린더 및 투두 리스트를 표시
- 빈 상태 메시지는 날짜별로 다르게 표시 (오늘, 미래, 과거)
- 플로팅 액션 버튼은 그라데이션 스타일 적용

### 2. 통계 화면
- 섹션 헤더를 이용해 각 통계 영역 구분
- 챠트와 그래프는 앱의 주요 색상 사용
- 뱃지와 레벨업 팁은 사용자 참여 유도 목적

### 3. 설정 화면
- 명확한 구분을 위한 AppCard 사용
- 스위치와 시간 선택기 등의 인터랙션 요소 통일

## 사용 방법

### 1. 테마 적용
앱의 메인 테마는 `lib/core/theme/app_theme.dart`에 정의되어 있으며, MaterialApp의 theme 속성에 적용됩니다.

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

### 2. 색상 사용
직접 Colors.blue와 같은 코드 대신 AppColors 클래스를 사용하세요.

```dart
// 잘못된 예
Container(color: Colors.blue)

// 올바른 예
Container(color: AppColors.primary)
```

### 3. 텍스트 스타일 사용
일관된 텍스트 스타일을 위해 AppTextStyles 클래스를 사용하세요.

```dart
// 잘못된 예
Text(
  '제목',
  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
)

// 올바른 예
Text(
  '제목',
  style: AppTextStyles.headline3,
)
```

### 4. 공통 위젯 사용
반복되는 UI 패턴은 공통 위젯을 활용하세요.

```dart
// 일반 버튼 사용
AppButton(
  label: '저장',
  onPressed: () => saveData(),
)

// 그라데이션 버튼 사용
GradientButton(
  label: '추가하기',
  onPressed: () => addItem(),
)

// 섹션 헤더 사용
SectionHeader(
  title: '주간 통계',
  icon: Icons.bar_chart,
)

// 카드 사용
AppCard(
  child: Column(
    children: [
      // 내용...
    ],
  ),
)

// 빈 상태 위젯 사용
EmptyStateWidget(
  icon: Icons.task_alt,
  title: '할 일이 없습니다',
  subtitle: '새로운 할 일을 추가해보세요',
)
```

## 디자인 통합 시 고려사항

### 1. 일관성 유지
- 모든 페이지에서 동일한 색상 팔레트와 텍스트 스타일 사용
- 유사한 요소는 동일한 스타일로 표현 (예: 모든 섹션 제목에 SectionHeader 사용)

### 2. 접근성
- 색상 대비를 고려하여 모든 사용자가 읽기 쉽도록 설계
- 충분한 사이즈의 터치 영역 제공 (최소 44x44px)

### 3. 반응형 디자인
- 다양한 화면 크기에 대응할 수 있는 레이아웃 설계
- MediaQuery와 LayoutBuilder 활용

### 4. 브랜드 아이덴티티
- 주요 색상(Primary, Secondary)은 앱의 브랜드 아이덴티티를 표현
- 일관된 디자인 언어로 사용자 경험 강화

## 코드 리팩토링 가이드

기존 코드를 디자인 시스템에 맞게 리팩토링할 때 다음 단계를 따르세요:

1. 직접 정의된 색상 코드를 AppColors 상수로 교체
2. 인라인 스타일 정의를 AppTextStyles로 교체
3. 반복되는 UI 패턴을 공통 위젯으로 교체
4. 화면 레이아웃 구조를 일관되게 유지 (예: 모든 화면에서 동일한 패딩 사용)

## 확장성

추후 다크 테마 지원이나 새로운 디자인 요소 추가 시, 기존 구조를 확장하여 사용할 수 있습니다.
- `AppTheme.darkTheme` 구현
- 새로운 색상이나 스타일 필요 시 해당 파일에 추가
