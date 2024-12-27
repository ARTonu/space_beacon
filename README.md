# Space Beacon

Where’s the ISS? Probably spying on your neighborhood—find out now!

## App Description

A simple Flutter app that fetches data from an open API and Firebase and displays it on the screen. Displays a special message, “The Space Station is above your Country Now!!”, if the ISS is over the user’s country.
The app consists of two screens:

1. **Login Screen**
    - Implements Firebase anonymous sign-in.
    - Automatically signs in the user anonymously on app launch.
    - Navigates to the home screen after a successful sign-in.

2. **Home Screen**
    - Displays:
        - **Latitude and Longitude** of the International Space Station (ISS).
        - **UTC and Local Time** of when the data was last updated.
        - **Country or Region** over which the ISS is currently located.
    - Auto-refreshes data every minute, showing a countdown timer for the next refresh.
    - Includes a button to manually refresh the data.

## App Demo

![App Preview](https://github.com/ARTonu/space_beacon/raw/refs/heads/main/dist/demo.gif)

## App Installation

[Download the APK](https://github.com/ARTonu/space_beacon/raw/refs/heads/main/dist/app-release.apk) and install it

## Source Code Build and Setup

### Prerequisites
- Flutter 3.24.5
- Dart SDK
- Android Studio or any preferred IDE with Flutter support.
- Firebase project configuration file (`google-services.json`).

### Steps
1. Clone the repository:
   ```bash
   git clone git@github.com:ARTonu/space_beacon.git
   cd space_beacon
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate assets and model classes:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

5. (Optional) To build an APK:
   ```bash
   flutter build apk
   ```
   The APK will be located in the `build/app/outputs/flutter-apk/` directory.

## Testing
- Tests are located in the `test/` directory.
- To run the tests:
  ```bash
  flutter test
  ```

## API Reference
- [ISS Current Location API](http://api.open-notify.org/iss-now.json)

