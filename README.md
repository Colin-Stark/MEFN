# Seneca Rate My Professor - MEFN (Mongo Express Flutter NodeJS)

## Overview

**Seneca Rate My Professor** is a cross-platform application that allows **Seneca College students** to register securely and rate their professors. Built using the **MEFN** stack (MongoDB, Express, Flutter, NodeJS), the app ensures that only authorized students can register, leveraging email verification, OTP authentication, and secure password policies. The app is designed with responsiveness in mind, providing a native look and feel across Android, iOS, web, and desktop platforms.

### Key Technologies

- **MongoDB**: Stores user registration details and OTP information.
- **Express**: Provides backend API support, handling OTP generation and validation.
- **Flutter**: Frontend framework used to build cross-platform user interfaces for mobile, web, and desktop.
- **NodeJS**: Server-side environment managing the backend logic and OTP validation.

## Features

### 1. **Email Verification**

The app only allows students with an official Seneca College email address (ending in `@myseneca.ca`) to register. Any other email addresses will be rejected to ensure the system is limited to Seneca students.

### 2. **OTP (One-Time Password) Verification**

- After successful email validation, users are prompted to verify their email through an OTP sent to the registered email address.
- The OTP is valid for **30 minutes**.
- If the OTP is incorrect or expired, registration will fail, ensuring a high level of security.

### 3. **Secure Password Policy**

- Passwords must meet the following criteria:
  - Minimum length: **8 characters**
  - Maximum length: **16 characters**
  - Strong passwords are recommended to enhance account security.

### 4. **Responsive UI Across Platforms**

- The app provides tailored experiences for different devices:
  - **Mobile (Android/iOS)**: Intuitive, touch-friendly UI designed to feel like a native app on both platforms.
  - **Web**: Responsive layouts optimized for different screen sizes, ensuring smooth user interaction.

### 5. **Backend Integration**

- The app is connected to a **NodeJS backend** hosted online, which handles:
  - OTP generation and email delivery using an SMTP server.
  - OTP validation, including expiration time checks.
  - Secure password handling and storage in a **MongoDB** database.

### 6. **Registration Flow**

- **Step 1**: User enters their Seneca College email address (`@myseneca.ca`).
- **Step 2**: A registration request is sent to the server. If the email is valid, an OTP is generated and sent to the user’s email.
- **Step 3**: The user enters the OTP within the app. The server verifies if the OTP is correct and within the 30-minute expiration period.
- **Step 4**: Upon successful OTP verification, the user can proceed to set up a password following the required policy.
- **Step 5**: The user’s details are saved, and registration is complete.

## Setup and Installation

### Prerequisites

- **Flutter SDK**: Ensure that Flutter is installed. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **NodeJS**: Make sure NodeJS is installed. Check [NodeJS installation](https://nodejs.org/en/download/prebuilt-installer).

### Running the Flutter App Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/Colin-Stark/MEFN.git
   ```
2. Navigate to the project folder:
   ```bash
   cd MEFN
   ```
3. Install the Flutter dependencies:
   ```bash
   flutter pub get
   ```
4. Start the app:
   - **Mobile (Android/iOS)**: Connect a device/emulator and run:
     ```bash
     flutter run
     ```
   - **Web**: Open Chrome and run:
     ```bash
     flutter run -d chrome
     ```

## Contributing

We welcome contributions to improve the app! Feel free to submit a pull request or open an issue.
