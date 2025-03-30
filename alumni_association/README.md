# Alumni Association Platform

## Project Overview
This Flutter application serves as a comprehensive platform for university alumni associations, featuring:
- **Dual user roles**: Students and Alumni with different dashboards
- **Job Portal**: Post and browse job opportunities
- **Event Management**: Create and RSVP to events
- **Donation System**: Secure contribution platform
- **Real-time Chat**: Communication between members
- **Light/Dark Theme**: User preference support

## Prerequisites
- Flutter SDK installed
- VS Code with Flutter extension
- Firebase account
- For Android emulation: Android Studio (recommended)
- For web development: Chrome browser

## Database Setup (Windows + VS Code)

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name "AlumniAssociation"
4. Enable Google Analytics (optional)
5. Click "Create project"

### Step 2: Set Up Authentication
1. In Firebase Console, go to Authentication → Sign-in method
2. Enable Email/Password provider
3. Click "Save"

### Step 3: Set Up Firestore Database
1. Go to Firestore Database in Firebase Console
2. Click "Create database"
3. Start in test mode (for development)
4. Select location closest to you
5. Click "Enable"

### Step 4: Create Collections
Run these commands in Firestore console:
```javascript
// Users collection
db.collection("users").add({
  uid: "sample-user-id",
  email: "test@example.com",
  name: "Test User",
  graduationYear: "2020",
  department: "Computer Science",
  isAlumni: true,
  createdAt: new Date()
});

// Jobs collection
db.collection("jobs").add({
  title: "Sample Job",
  company: "Tech Corp",
  description: "Sample job description",
  location: "New York",
  postedBy: "sample-user-id",
  postedAt: new Date()
});

// Events collection
db.collection("events").add({
  title: "Alumni Meet",
  description: "Annual gathering",
  date: new Date("2023-12-15"),
  location: "University Campus",
  organizer: "sample-user-id",
  createdAt: new Date()
});
```

### Step 5: Configure FlutterFire
1. Open terminal in VS Code (Ctrl+`)
2. Run:
```bash
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
```

3. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

4. Configure Firebase:
```bash
flutterfire configure
```
- Select your Firebase project
- Select platforms (Android, iOS, Web)
- Configuration files will be auto-generated

## Step 6: Run the Application
You have multiple options:

### Option 1: Web (No Android Studio needed)
1. In VS Code terminal:
```bash
flutter pub get
flutter run -d chrome
```

### Option 2: Android (Requires Android Studio)
1. Install Android Studio
2. Set up an Android Virtual Device (AVD)
3. In VS Code terminal:
```bash
flutter pub get
flutter run -d emulator-5554
```

### Option 3: Physical Device
1. Enable Developer options on your Android phone
2. Enable USB debugging
3. Connect via USB
4. In VS Code terminal:
```bash
flutter pub get
flutter run -d your_device_id
```

## Project Structure
```
lib/
├── main.dart          # App entry point
├── screens/           # All UI screens
├── services/          # Firebase services
├── models/            # Data models
├── widgets/           # Reusable components
└── utils/             # Helpers & constants
```

## Troubleshooting
1. **Firebase not initialized**:
   - Ensure `firebase_options.dart` is properly generated
   - Verify Firebase project configuration

2. **Database permission denied**:
   - Check Firestore rules in Firebase Console
   - Update rules if in test mode:
     ```
     rules_version = '2';
     service cloud.firestore {
       match /databases/{database}/documents {
         match /{document=**} {
           allow read, write: if true;
         }
       }
     }
     ```

3. **Authentication issues**:
   - Verify Email/Password provider is enabled
   - Check user collection structure matches code

## Next Steps
- Implement push notifications
- Add alumni directory search
- Develop mentorship features
- Add profile editing functionality