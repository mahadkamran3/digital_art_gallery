# mad_project

A cross-platform Flutter art gallery app.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Git](https://git-scm.com/downloads)
- IDE: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- For mobile: Android/iOS emulator or device
- For desktop: Windows, macOS, or Linux (see [Flutter desktop docs](https://docs.flutter.dev/platform-integration/desktop))
- For web: Chrome, Edge, or Firefox browser

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/mahadkamran3/digital_art_gallery
   cd digital_art_gallery
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Check your environment:**
   ```sh
   flutter doctor
   ```
   Follow any instructions to fix issues (e.g., install missing tools).

## Running the App

### Android
- Start an emulator or connect a device.
- Run:
  ```sh
  flutter run -d android
  ```

### iOS
- Requires macOS and Xcode.
- Start a simulator or connect a device.
- Run:
  ```sh
  flutter run -d ios
  ```

### Web
- Run:
  ```sh
  flutter run -d chrome
  ```
  Or use `edge` or `firefox` as device.

### Windows
- Run:
  ```sh
  flutter run -d windows
  ```

### macOS
- Run:
  ```sh
  flutter run -d macos
  ```

### Linux
- Run:
  ```sh
  flutter run -d linux
  ```

## Environment & Sensitive Data
- Do **not** commit secrets, API keys, or credentials. See `.gitignore` for excluded files.
- If you use environment variables, create a `.env` file and keep it private.
- For Android, do not commit `local.properties` or `google-services.json`.

## Troubleshooting
- If you see dependency errors, run:
  ```sh
  flutter pub get
  ```
- If you see platform errors, check `flutter doctor` output.
- For web, use Chrome for best compatibility.
- For desktop, ensure you have the required OS and toolchain.

## Features
- Art feed with like, comment, and share functionality
- Upload and view artworks
- Persistent interaction counts (likes, comments)
- Responsive UI for mobile, web, and desktop

## Contributing
Pull requests are welcome! For major changes, please open an issue first.

## License
Specify your license here.
