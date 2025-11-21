# 🐾 PawPal - Pet Adoption & Donation App

This project is the User Authentication Module for the PawPal mobile application. It demonstrates secure user registration and login functionality using a Flutter frontend and a PHP/MySQL backend.

## ✨ Features

### User Registration:
- Form validation (Empty fields, Password length, Email format).
- Checks for duplicate emails in the database.
- Secure password hashing using SHA1.

### User Login:
- Authentication against MySQL database.
- "Remember Me" feature using Shared Preferences to persist user credentials.

### Feedback:
- SnackBars for success/error messages.
- Loading dialogs during network requests.

## 🛠️ Tech Stack
- Frontend: Flutter (Dart)
- Backend: PHP
- Database: MySQL (phpMyAdmin)

## 🚀 Setup Instructions

1. Database Setup

Create a database named pawpal_db in phpMyAdmin.

Run the following SQL command to create the user table:

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`)
);


2. Backend Setup

Place the php folder inside your local server directory (e.g., C:\xampp\htdocs\pawpal\php).

Ensure your server (Apache & MySQL) is running.

Update dbconnect.php with your database credentials if necessary.

3. Frontend Setup

Open the Flutter project in VS Code.

Open lib/config.dart.

Crucial: Change the baseUrl to your computer's local IP address (Run ipconfig in CMD to find it).

class Config {
  static const String baseUrl = 'http://YOUR_IPV4_ADDRESS';
}


Run flutter pub get to install dependencies.

Run the app on your emulator or physical device.

## 📂 Project Structure
- lib/models/: Contains the User data model.
- lib/screens/: Contains LoginScreen, RegisterScreen, and HomeScreen.
- php/: Contains login_user.php, register_user.php, and dbconnect.php.

## App Screenshot
<div align="center">
  <img src="assets/images/screenshot%20registerscreen.png" width="30%" />
  <img src="assets/images/screenshot%20loginscreen.png" width="30%" />
  <img src="assets/images/screenshot%20homescreen.png" width="30%" />
</div>

### Developed by [WEE JUN JEANG]