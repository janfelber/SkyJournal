[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-57b9d3.svg?style=flat&logo=Flutter)]((https://flutter.dev/))
[![Maps SKD used](https://img.shields.io/badge/Maps%20SDK-GoogleMaps-4285F4.svg?style=flat&logo=GoogleMaps)](https://developers.google.com/maps)
[![Database Used](https://img.shields.io/badge/Dataabse%20-Firebase-4285F4.svg?style=flat&logo=Firebase&label=%20Database&color=FFA000)](https://developers.google.com/maps)




# Electronic Pilot Logbook Application

## Introduction
This repository hosts the source code for a pilot logbook application developed as a bachelor's thesis project to streamline the management of flight data for pilots. The application aims to provide a user-friendly interface for pilots to record and manage their flight hours, and related details. It includes features such as Google Maps integration to visualize flight routes, the ability to add pilot license information. Additionally, the application utilizes push notifications to remind users of upcoming medical examinations and license expirations.
## Google Maps IOS
``` dart
import UIKit
import Flutter
import GoogleMaps 
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY") // add your api key here from google cloud console - https://console.cloud.google.com/

    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Securing Google Maps API Key
For security reasons, the example code provided includes a placeholder "YOUR_API_KEY" for the Google Maps API key. It's important to replace this placeholder with your actual API key obtained from the [Google Cloud Console](https://console.cloud.google.com/).

Before the route visualization feature can function properly, it's necessary to replace the "YOUR_API_KEY" placeholder with your own API key in the appropriate section of the code.

## Setting up Google Services for Android
For database usage on Android devices, it's necessary to set up Google Services information. Since the application was developed on an Apple device, additional steps are required for proper communication with the database on Android.

1. **Configure Google Services**: Follow the instructions provided in the [Firebase documentation](https://firebase.google.com/docs/flutter/setup?platform=android#configure_an_android_app) to configure your Android app with Google Services.

2. **Add Google API Key**: Place your Google API key in the appropriate location within the Android project. This key is required for functionalities such as Google Maps integration.

Please ensure that these steps are completed to enable proper functionality on Android devices.


## Features
- **Flight Entry Management**: Easily input and manage flight details such as date, aircraft type, airports, registration, time of takeoff, time of landing, function of the pilot during the flight, airline, numbers of passengers, and average flight speed. Please note that certain details such as average speed and number of passengers are generated randomly as we do not have access to real flight data.
- **Data Visualization**: Gain insights through graphical representations of flight hours and other statistics.
- **Cloud Integration**: Backup and synchronize logbook data across devices seamlessly using Firebase.
- **Google Maps Integration**: Visualize flight routes using Google Maps for enhanced visualization.
- **Pilot License Management**: Add and manage pilot license information, including expiration dates and renewal reminders.
- **Mandatory Examinations Schedules**: Schedule mandatory examinations schedules and receive push notifications for upcoming examinations.
- **Push Notifications**: Receive notifications for scheduled mandatory examinations and license expiration dates to stay informed and compliant. These functionalities are implemented using Firebase Functions and can be found in the `functions` directory within the project's source code.


## Flaticon Icon Usage
Some icons are sourced from Flaticon and integrated into the application's user interface to enhance visual appeal. These icons are used solely for educational purposes, with proper attribution provided as per Flaticon's guidelines.

## Technologies Used
- **Flutter**: The application is developed using Flutter, a cross-platform framework for building mobile applications.
- **Google Maps SDK**: Integrated for displaying flight routes and navigation within the application.
- **Firebase Database**: Utilized for cloud-based storage and synchronization of logbook data across devices.
