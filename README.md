# 🐾 PawPal - Pet Adoption & Donation App

## ✨ Features

- User registration and login
- Public pet listing with search and filter
- Pet details and adoption request
- Donation module (Food, Medical, Money)
- Online payment using Billplz
- Donation history
- User profile and edit profile (including profile image upload)

## 🚀 Setup Instructions

### 1. Backend & Database Setup
1. **Deploy Server Files:**
   - Copy the `pawpal` folder (from the `server` directory) inside your project.
   - Paste it into your local web server directory:
     - Windows (XAMPP): `C:\xampp\htdocs\`
     - Mac/Linux: `/var/www/html/`
   - *Note: Ensure the folder in htdocs is named `pawpal`.*

2. **Database Configuration:**
   - Open your database management tool (e.g., phpMyAdmin).
   - Create a new database.
   - Import the SQL file located at: `database/canortxw_junjeang_pawpal_db.sql`
   - Open the `dbconnect.php` file in your `htdocs/pawpal` folder and update the credentials:
     ```php
     $servername = "localhost";
     $username   = "root"; 
     $password   = "";     
     $dbname     = "yourdbname";
     ```

3. **Payment Gateway Setup (Billplz):**
   - **`payment.php`**: Update your API Key and Collection ID.
     ```php
     $api_key = 'your_actual_api_key';
     $collection_id = 'your_actual_collection_id';
     ```
   - **`payment_update.php`**: Update the X-Signature key for verification.
     ```php
     $signed = hash_hmac('sha256', $signing, 'your_actual_x_signature');
     ```

### 2. Flutter App Setup

1. **Install Dependencies:**
   - Open the terminal in the project root and run:
     ```bash
     flutter pub get
     ```

2. **Configure Backend URL (Critical):**
   - Open `lib/myconfig.dart`.
   - **Do not use localhost** if testing on a physical device or Android emulator.
   - Use your machine's IP address (Run `ipconfig` on Windows or `ifconfig` on Mac to find it).
     ```dart
     // Example format:
     static const String baseUrl = "[http://192.168.](http://192.168.)x.x/pawpal";
     ```

3. **Run the App:**
   ```bash
   flutter run

## 📡 API Usage

| No | API | Method | Purpose |
|----|---------------------------|--------|-------------------------------------------|
| 1 | get_user_profile.php | GET | Retrieve logged-in user profile |
| 2 | update_profile.php | POST | Update user name, phone, and profile photo |
| 3 | get_public_pets_listing.php | GET | Retrieve all pets for public listing |
| 4 | submit_adoption.php | POST | Submit adoption request |
| 5 | submit_donation.php | POST | Submit food or medical donation |
| 6 | payment.php | GET | Open Billplz payment page |
| 7 | payment_update.php | GET | Verify payment and record money donation |
| 8 | get_my_donations.php | GET | Retrieve donation history of logged-in user |