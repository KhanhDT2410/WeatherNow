# Bảng Điều Khiển Thời Tiết

Ứng dụng Flutter đa nền tảng dùng để lấy dự báo thời tiết theo vị trí hiện tại của người dùng. Dự án được xây dựng theo hướng một weather dashboard hiện đại, responsive, hỗ trợ mobile, tablet, desktop và web, đồng thời giữ logic lấy dữ liệu gọn và dễ bảo trì.

## Mục tiêu dự án

- Lấy vị trí hiện tại của thiết bị bằng GPS hoặc Location Services
- Gọi API thời tiết để lấy dữ liệu thời tiết hiện tại và dự báo 5 ngày
- Hiển thị giao diện dashboard hiện đại, có animation và responsive tốt
- Hỗ trợ tiếng Việt có dấu chuẩn UTF-8
- Tái sử dụng cùng một codebase Flutter cho Android, iOS, web và desktop

## Tính năng chính

- Lấy vị trí hiện tại bằng `geolocator`
- Gọi Open-Meteo API bằng `http`
- Hiển thị:
  - Nhiệt độ hiện tại
  - Trạng thái thời tiết
  - Cảm giác nhiệt độ
  - Độ ẩm
  - Tốc độ gió
  - Múi giờ
  - Dự báo 5 ngày
- Loading state, empty state và error state rõ ràng
- Nút làm mới có animation
- Card có hover effect cho web/desktop
- Tap/ripple feedback cho mobile
- Giao diện responsive theo breakpoint

## Công nghệ sử dụng

- Flutter
- Dart
- `geolocator`
- `http`
- Material 3

## Nguồn dữ liệu

Ứng dụng hiện dùng Open-Meteo để lấy dữ liệu dự báo thời tiết:

- `https://api.open-meteo.com/v1/forecast`

Dữ liệu hiện tại bao gồm:

- `temperature_2m`
- `apparent_temperature`
- `relative_humidity_2m`
- `weather_code`
- `wind_speed_10m`
- `is_day`

Dữ liệu dự báo ngày bao gồm:

- `weather_code`
- `temperature_2m_max`
- `temperature_2m_min`

## Cấu trúc thư mục

Phần code ứng dụng chính nằm trong thư mục `lib/`.

```text
lib/
├─ main.dart
├─ app/
│  └─ weather_app.dart
├─ theme/
│  ├─ app_theme.dart
│  └─ app_tokens.dart
└─ features/
   └─ weather/
      ├─ models/
      │  └─ weather_report.dart
      ├─ presentation/
      │  ├─ weather_formatters.dart
      │  └─ weather_page.dart
      ├─ services/
      │  └─ weather_api.dart
      └─ widgets/
         ├─ current_weather_card.dart
         ├─ forecast_section.dart
         ├─ loading_refresh_button.dart
         ├─ location_card.dart
         ├─ metric_chip.dart
         ├─ motion_reveal.dart
         ├─ state_cards.dart
         ├─ surface_card.dart
         ├─ weather_header.dart
         └─ weather_shell.dart
```

## Kiến trúc hiện tại

### 1. Entry point

- `lib/main.dart`

Chỉ có nhiệm vụ khởi tạo Flutter binding và chạy `WeatherApp`.

### 2. App shell

- `lib/app/weather_app.dart`

Chứa `MaterialApp`, theme trung tâm và root screen.

### 3. Theme system

- `lib/theme/app_tokens.dart`
- `lib/theme/app_theme.dart`

Quản lý:

- màu sắc
- spacing
- radius
- shadow
- breakpoint responsive
- typography

### 4. Feature weather

#### Models

- `weather_report.dart`

Định nghĩa:

- `WeatherReport`
- `DailyForecast`

#### Service

- `weather_api.dart`

Giữ logic gọi API thời tiết. Public API hiện tại:

```dart
WeatherApi.fetchForecast({
  required double latitude,
  required double longitude,
})
```

#### Presentation

- `weather_page.dart`

Chứa stateful flow chính:

1. xin quyền vị trí
2. lấy tọa độ hiện tại
3. gọi API thời tiết
4. cập nhật UI

State management hiện tại dùng:

- `StatefulWidget`
- `setState`

#### Widgets

Các phần UI được tách riêng để dễ bảo trì:

- `weather_header.dart`: hero header, trạng thái và nút làm mới
- `location_card.dart`: hiển thị vị trí hiện tại và trạng thái quyền
- `current_weather_card.dart`: nhiệt độ hiện tại và nhóm chỉ số chính
- `metric_chip.dart`: các ô thông tin nhỏ
- `forecast_section.dart`: khu vực dự báo 5 ngày
- `state_cards.dart`: loading, error, empty
- `surface_card.dart`: card dùng chung có hover/tap effect
- `motion_reveal.dart`: hiệu ứng fade + slide
- `weather_shell.dart`: nền gradient và layout wrapper toàn màn hình

## Responsive layout

Breakpoint hiện tại:

- Mobile: `< 720`
- Tablet: `720 - 1099`
- Desktop/Web: `>= 1100`
- Max content width: `1280`

Hành vi layout:

- Mobile: 1 cột, ưu tiên phần quan trọng lên trước
- Tablet: 1 cột rộng, spacing thoáng hơn
- Desktop/Web: 2 cột, bố cục rộng nhưng không kéo giãn toàn màn hình

## UI/UX nổi bật

- Gradient background theo phong cách thời tiết
- Card bo góc lớn, shadow mềm, hiệu ứng hover nhẹ
- Hero section rõ điểm nhấn
- Nhiệt độ hiện tại là trọng tâm thị giác
- Các trạng thái thời tiết có màu và icon riêng
- Animation khi dữ liệu xuất hiện:
  - fade in
  - slide up
  - hover lift
- Nút refresh có loading animation
- Toàn bộ text hiển thị đã chuẩn hóa sang tiếng Việt có dấu

## Quyền truy cập vị trí

Ứng dụng cần quyền vị trí để lấy dữ liệu thời tiết chính xác hơn.

### Android

Đã khai báo trong:

- `android/app/src/main/AndroidManifest.xml`

Bao gồm:

- `INTERNET`
- `ACCESS_COARSE_LOCATION`
- `ACCESS_FINE_LOCATION`

### iOS

Đã khai báo:

- `NSLocationWhenInUseUsageDescription`

Trong:

- `ios/Runner/Info.plist`

### macOS

Đã khai báo:

- `NSLocationUsageDescription`
- entitlement cho location sandbox

Trong:

- `macos/Runner/Info.plist`
- `macos/Runner/DebugProfile.entitlements`
- `macos/Runner/Release.entitlements`

## Cách chạy dự án

### 1. Cài dependency

```bash
flutter pub get
```

### 2. Chạy app

```bash
flutter run
```

### 3. Chạy trên web

```bash
flutter run -d chrome
```

### 4. Build web

```bash
flutter build web --debug
```

### 5. Phân tích mã nguồn

```bash
flutter analyze
```

## Yêu cầu môi trường

- Flutter SDK tương thích với Dart `^3.11.4`
- Thiết bị thật hoặc emulator có bật dịch vụ vị trí nếu muốn test GPS

### Lưu ý cho Windows desktop

Khi build Windows với plugin, hệ thống có thể yêu cầu bật Developer Mode để hỗ trợ symlink:

- `Settings > For developers > Developer Mode`

## Kiểm thử và xác minh

Đã xác minh trong quá trình phát triển:

- `flutter analyze`: pass
- `flutter build web --debug`: pass

Nếu chạy test widget trong một số môi trường bị treo, hãy ưu tiên dùng:

- `flutter analyze`
- `flutter run`
- `flutter build web`

để xác nhận trạng thái build thực tế của ứng dụng.

## Luồng hoạt động của ứng dụng

1. App khởi động từ `main.dart`
2. `WeatherPage` được render
3. Ứng dụng kiểm tra dịch vụ vị trí
4. Xin quyền truy cập vị trí nếu cần
5. Lấy `latitude` và `longitude`
6. Gọi `WeatherApi.fetchForecast(...)`
7. Parse dữ liệu sang `WeatherReport`
8. Render dashboard theo trạng thái hiện tại

## Định hướng mở rộng

Một số hướng mở rộng phù hợp cho dự án:

- thêm chọn thành phố thủ công
- lưu lịch sử tìm kiếm
- thêm biểu đồ nhiệt độ 5 ngày
- thêm dark mode theo ngữ cảnh ngày/đêm
- thêm cache dữ liệu thời tiết gần nhất
- thêm localization đa ngôn ngữ

## Tài liệu tham khảo

- Flutter Docs: `https://docs.flutter.dev/`
- Geolocator: `https://pub.dev/packages/geolocator`
- Open-Meteo: `https://open-meteo.com/`

## Ghi chú

Project hiện được tổ chức theo hướng feature-based ở mức gọn nhẹ, đủ sạch để tiếp tục mở rộng mà chưa cần state management phức tạp như BLoC hay Riverpod. Nếu ứng dụng tăng thêm nhiều màn hình hoặc nhiều nguồn dữ liệu, có thể tiếp tục tách layer repository và state management ở bước sau.
