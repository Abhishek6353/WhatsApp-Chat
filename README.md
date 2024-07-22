# WhatsApp Chat
Welcome to the WhatsApp Chat project! This project is an iOS application that replicates the core functionalities of WhatsApp, allowing users to send and receive messages in real-time.


## Features

### User
  - Authentication with mobile number
  - Logout
  - Profile info


### UserReal-time Messaging
  - Send and receive text messages
  - Message timestamps
  - Online status and last seen


### UserChat List
  - List of recent chats


## Installation

### Prerequisites
- macOS
- Xcode
- CocoaPods
- Firebase Account


### Steps
1. Clone the repository:

   ```bash
   git clone https://github.com/Abhishek6353/WhatsApp-Chat.git
   cd WhatsApp-Chat

2. Install Dependencies:

   ```bash
   pod install

3. Configure Firebase:
 - Create a new project in the Firebase Console.
 - Add an iOS app to your Firebase project.
 - Download the GoogleService-Info.plist file and add it to the root of your Xcode project.
 - Enable Firebase Authentication, Firestore, and Storage in the Firebase Console.


4. Open the project in Xcode:

   ```bash
   open WhatsApp-Chat.xcworkspace


5. Build and run the app:
 - Select your target device or simulator.
 - Click the "Run" button in Xcode.

