# T_Admin_Panel - Flutter E-Commerce Solution

Flutter - https://flutter.dev
Firebase - https://firebase.google.com
Admin Panel Preview - https://tstore.codingwitht.com

## 📜 License Compliance Notice

**IMPORTANT LEGAL NOTICE**
This codebase is licensed software. You **MUST** purchase either:
- **Basic Tier** (Personal Project Only)
- **Professional Tier** (Resale Rights)
- **Enterprise Tier** (Resale Rights)

To obtain proper licensing:
🔗 [Purchase License](https://codingwitht.com/flutter-ecommerce-app-with-tutorials/)
📄 [View End User License Agreement](https://codingwitht.com/end-user-license-agreement/)

### Usage Restrictions:
- ❌ Code modification/distribution without valid license
- ❌ Reselling without Professional Tier
- ❌ White-labeling without Enterprise Tier
- ❌ Production use without active subscription
- ❌ Removing copyright notices

Violations will result in:
- Immediate license revocation
- Legal action under DMCA provisions
- Permanent blacklisting from updates

---



## Introduction ✨

Production-ready e-commerce admin solution built with:

- **Flutter** for cross-platform UI
- **Firebase** backend (Auth, Firestore, Storage)
- **GetX** state management
- Clean Architecture

---

## 🚀 Quick Start

### 1. Load Flutter Packages
  ```bash
   flutter pub get
  ```



### 2. Firebase Configuration

 * Initial Setup

   1. Install Firebase CLI
   2. Connect project:
      1. Initialize Firebase in your local project
         - Install the Firebase CLI (if you haven’t already):
           ```shell
             npm install -g firebase-tools
           ```
         - Log in and select your project:
           ```shell
             firebase login
           ```
           ```shell
             firebase use --add
           ```
         - In your Flutter Project root, run:
         - NOTE: Make sure to remove the already attached project from .firebaserc file.
         - Remove this line if exist
         - ```shell
            "default": "codingwitht-c6d0f"
           ```
         - After that run  
           ```shell
             flutterfire configure
           ```
         - Choose the Firebase project, platforms (iOS/Android/Web), 
         - and generate the firebase_options.dart file.


 * Services Activation

 1. Enable in Firebase Console:
    * Authentication (Email/Password)
    * Firestore Database (Test mode)
    * Storage

 * SHA Keys (Android)
  # Mac/Linux
  ```bash 
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```

  # Windows
  ```bash
   keytool -list -v -keystore "C:\Users\YourPC\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
  ```
  Add output SHA1/SHA256 to Firebase Project Settings > Your App




### 3. 🔥 Database Configuration
  * Firestore Indexes 
   - Create these indexes in Firebase Console > Firestore > Indexes:

   - **Collection ID** : **Fields indexed**

   - Orders: userId Ascending, updatedAt Descending, __name__ Descending
   - Orders: userId Ascending createdAt Descending __name__ Descending
   - Images: mediaCategory Ascending, createdAt Descending, __name__ Descending
   - Products:	isActive Ascending, isDeleted Ascending, isDraft Ascending, title Ascending, lowerTitle Ascending, __name__ Ascending
   - Banners: isActive Ascending, isFeatured Ascending, createdAt Descending, endDate Descending, startDate Descending, __name__ Descending

   - **Query scope**
   - Collection




### 4. ☁️ Storage Configuration

* CORS Setup
  1. Open Google Cloud Console (https://console.cloud.google.com/)
  2. Activate Cloud Shell (top-right) and run:
     ```shell
      echo '[{"origin":["*"],"method":["GET","HEAD"],"responseHeader":["Content-Type"],"maxAgeSeconds":3600}]' > cors-config.json
     ```
  3. Replace ~~YOUR_BUCKET_NAME~~ with your actual bucket which is in the
     Firebase Console -> Storage -> Copy the gs://... bucket name and replace with the below command.
     ```shell
      gsutil cors set cors-config.json gs://YOUR_BUCKET_NAME
     ```
     - Run this command in the Google shell terminal and you are done. 

  4. To check if everything worked as expected, you can get the cors-settings of a bucket with the
     following command:
  
     ```shell
      gsutil cors get gs://YOUR_BUCKET_NAME
     ```



### 5. ☁️ Cloud Functions Deployment
   - Initialize Cloud Functions Directory 
   - From your project root, run:
     ```shell
       firebase init functions
     ```
   - NOTE: Select JavaScript, enable ESLint, & do not modify `index.js`.

  - Prerequisites:
   - Node.js v18.16.0+
   - npm v9.5.1+

   1. Initialize Functions
        ```bash
        cd functions
        ```
        ```bash
        npm install
        ```
   2. Deploy Functions
      ```shell
      firebase deploy --only functions
      ```

  ##### Common Issues & Solutions:
-  **Issue**	                **Solution**
-   403 PERMISSION_DENIED:	Add Cloud Functions Admin role in IAM
-   Dependency Error:  	    Run rm -rf node_modules && npm install
-   Deployment Timeout:	    Increase timeout in package.json: "engines": {"node": "18"}
-   Region Mismatch:	    Specify region in function declaration: functions.region('us-central1')




### 6. 👑 Admin Setup
  1. Modify lib/features/authentication/screens/login/widgets/login_form.dart:
     ```shell
        // Change this line
        controller.emailAndPasswordSignIn() 
        // To
        controller.registerAdmin()
     ```
  2. Run the code and add admin credentials in the Form fields & press `Register Admin` button.
     Wait for the admin to be registered.
  3. Revert back to login method once Admin setup in done.
     ```shell
        // Change this line
        controller.registerAdmin() 
        // To
        controller.emailAndPasswordSignIn() 
     ```

### 7. 🚀 Deployment
  #### Firebase Web Hosting
  - Initialize Hosting
    If you haven’t already:
    ```shell
     firebase init hosting
    ```

  - Build project:
   ```shell
     flutter clean 
   ```
   ```shell
     flutter build web --release --no-tree-shake-icons
   ```
  - Deploy Hosting on Default Hosting Domain:
   ```shell
     firebase deploy --only hosting
   ```
  - Deploy Hosting on your Custom Domain:
  - `firebase deploy --only hosting:YOUR_HOSTING_NAME`
  ```shell
   firebase deploy --only hosting:tstore-admin
  ```



### 8. 🛠 Support
For assistance contact our technical team:

    📧 Email: support@codingwitht.com
    🌐 Website: https://codingwitht.com
    📞 WhatsApp: +44-7456-285429



### 9. 📄 License
MIT © Coding with T

## ⚖️ Legal Compliance
All users except Enterprise users must display this notice prominently in application:

* Copyright (C) 2025 Coding with T.
* Licensed under Professional Tier (PID: #{your_license_id OR your_order_id}).
* Unauthorized use violates EULA (End User License Agreement) and may result in legal action.