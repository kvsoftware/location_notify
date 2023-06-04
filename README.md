# Location Notify
Welcome to Location Notify, a Flutter-based application.

## Introduction
Location Notify is an app that notifies users when they are near a specified location, allowing them to save their favorite places. It was inspired by my personal experiences of traveling by bus or train to unfamiliar locations, where it alerts me when I am close to a place without the need to frequently open Google Maps.

## Feature
- Save locations and receive notifications when you are nearby. This convenient feature makes it quick and easy to set up notifications for your preferred places.
- Adjust the notification radius to personalize your preferences. Customize the distance at which you receive alerts for your selected locations.

## Installation
To get started with the Location Notify mobile application, follow these steps:

1. Clone the repository to your local machine:
```
git clone https://github.com/kvsoftware/location_notify
```

2. Navigate to the project directory:
```
cd location_notify
```

3. Configure the Google Maps API keys:

3.1. Android, go to android/local.properties. Add the value of Google Maps API keys for Android
```
googleMapsApiKey=Your Google Maps Api keys
```

3.2. iOS, go to ios/Flutter/Debug.xcconfig. Add the value of Google Maps API keys for iOS
```
GOOGLE_MAPS_API_KEY=Your Google Maps Api keys
```

4. Install the necessary dependencies, generate the needed files, wait for success, and leave it as it is:
```
sh build.sh
```

5. Open a new terminal, connect your mobile device or emulator, and run the application.
```
flutter run
```

Feel free to explore the Location Notify application without worrying about missing any specified locations. Enjoy your trip with the app!
