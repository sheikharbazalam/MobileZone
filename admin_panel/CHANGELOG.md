## 2.0.0
### Cloud Function Integration
1. **Prerequisites**:
  - Installed Node.js (v18 or later) and Firebase CLI (`npm install -g firebase-tools`).
  - Firebase Project initialized:.
    - Created a Firebase project in the Firebase Console.
    - Added the Flutter app to this Firebase project.
  - Enabled Billing by upgrading to the Blaze (**Pay-as-you-go**) plan
2. **Initialization**:
 - Navigated to the project directory (`cd <your flutter project>`).
 - Initialized Firebase Cloud Functions using `firebase init` functions with the following options:
    - Language: `JavaScript`.
    - Enabled ESLint for linting.
    - Installed dependencies.
 - Created a `functions/` directory with the basic setup.
3. **Deployment**:
- Fixed `module/require` errors by creating an empty `eslint.config.js` file in the functions folder.
- Deployed Cloud Functions using `firebase deploy --only functions`.
- **Cloud Functions Added**:
 
## 2.0.0
### Cloud Function Integration
- **Cloud Functions Added**:
- **Assign Admin Role**: Assigns admin role during registration in Firebase Auth.
- **Manage Users**: Functions to create and delete users in Firebase Authentication.
- **Updated Authentication Repository** to handle Cloud Functions integration.

## 1.2.8
### Repository Refactoring
- **Introduced a Base Class** for repositories to clean up code and ensure consistency. 
- Established parent-child relationships for repositories using OOP principles.

## 1.2.7
### Login Design Enhancements
- **Login Design**: Updated with Left and Right Sections for better responsiveness and modern UI.
- **Forget Password Screen**: Improved for a better mobile view experience.
- **Login Template (`TLoginTemplate`)**: Enhanced to support responsiveness and accommodate new UI sections.

## 1.2.6
### Product Enhancements
- **Product Design**: Added new widget for Text with Icon `TTextWithIcon` & `TFormHeadingWithIcon`
- **Product Description Editor**: `Quill Text Editor` added instead of simple `textfield`
- **Product Visibility**: Now you can **Draft** your product or make it **Live** when ready.
- **Product Tags**: Introduced `tags` for products, enabling advanced search functionality and improving product discoverability based on associated tags.