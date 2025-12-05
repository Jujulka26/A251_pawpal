# 🐾 PawPal - Pet Adoption & Donation App

## ✨ Features
### 1. User Registration & Login
### 2. Pet Listing & Submit Pet

## 🚀 Setup Instructions
### 1. Backend Setup (XAMPP)
1. Copy the `pawpal` folder into your XAMPP `htdocs` directory (e.g., `C:\xampp\htdocs\pawpal`).
3. Open **phpMyAdmin** and create a database.
4. Import the `pawpal_db.sql` file included in this repository.

### 2. Flutter App Setup
1. Open the project in VS Code.
2. Open `lib/myconfig.dart` (or wherever your base URL is defined).
3. Change the IP address to your machine's local IP:
   ```dart
   static const String baseUrl = "http://192.168.x.x";

## 📡 API Explanation

### 1. Submit Pet Endpoint
**URL:** `POST /pawpal/api/submit_pet.php`

**Purpose:** Receives pet details and images to store in the database.

**Parameters (Body):**
| Parameter | Type | Description |
| :--- | :--- | :--- |
| `user_id` | String | ID of the user submitting the pet. |
| `pet_name` | String | Name of the pet. |
| `pet_type` | String | Selected type (Cat, Dog, Rabbit, Other). |
| `category` | String | Selected category (Adoption, Help). |
| `description` | String | Description text. |
| `lat` | String | Latitude coordinate. |
| `lng` | String | Longitude coordinate. |
| `image_paths` | Array | List of Base64 encoded image strings. |

---

### 2. Load Pets Endpoint
**URL:** `GET /pawpal/api/load_pets.php`

**Purpose:** Retrieves a paginated list of pets for the specific user.

**Parameters (Query String):**
| Parameter | Type | Description |
| :--- | :--- | :--- |
| `user_id` | String | **Required.** Filters list to show only this user's pets. |
| `search` | String | **Optional.** Keywords to filter by name/type. |
| `curpage` | Int | **Optional.** Page number for pagination (Default: 1). |

## 📦 Sample JSON Data

### 1. Submit Pet Response
**File:** `submit_pet.php`
```json
{
  "success": true,
  "message": "Pet submitted successfully"
}
````
### 2. Load Pets Response
**File:** `load_pets.php`
```json
{
  "status": "success",
  "numofpage": 1,
  "numberofresult": 1,
  "data": [
    {
      "pet_id": "3",
      "user_id": "1",
      "pet_name": "Meow",
      "pet_type": "Cat",
      "category": "Help/Rescue",
      "description": "A green cat",
      "image_paths": "uploads/pet_1_693356a8698f3_0.jpg,uploads/pet_1_693356a869919_1.jpg,uploads/pet_1_693356a869929_2.jpg",
      "lat": "37.4219983",
      "lng": "-122.084",
      "created_at": "2025-12-06 06:03:20",
      "name": "Jun",
      "email": "jun@gmail.com",
      "phone": "0123456789",
      "reg_date": "2025-12-04 20:45:04"
    }
  ]
}
```

## 📸 App Screenshot
<div align="center">
  <img src="assets/images/screenshot%20registerscreen.png" width="30%" />
  <img src="assets/images/screenshot%20loginscreen.png" width="30%" />
</div>
<div align="center">
  <img src="assets/images/screenshot%20mainscreen.png" width="30%" />
  <img src="assets/images/screenshot%20submitpetscreen.png" width="30%" />
</div>
