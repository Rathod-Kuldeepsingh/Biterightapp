# 🍏 BiteRightApp – Your Smart Food Companion

> A powerful mobile app that helps users **scan**, **analyze**, and **choose healthy packaged foods** based on their personal health needs.  
> Built using **Flutter** + **Firebase** + **OpenFoodFacts API** 💻📱

---

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blueviolet?style=for-the-badge)

---

## 📦 Overview

🧠 **BiteRight** is a smart nutrition advisor designed for the health-conscious generation.  
It scans food product barcodes and provides real-time insights into:

- Nutritional value 🍽️
- Harmful ingredients ⚠️
- Allergens 🤧
- Personalized health compatibility ✅
- Healthier product alternatives 💡

---

## 🧩 Core Features

| Feature                         | Description                                                                 |
|-------------------------------|-----------------------------------------------------------------------------|
| 🔍 Barcode/QR Scanning         | Instant scan of packaged food via barcode or QR                             |
| 📊 Nutritional Breakdown       | Visual display of calories, carbs, sugar, fats, etc.                        |
| 🧪 Harmful Additives Detection | Highlights potentially dangerous E-numbers and additives                    |
| ✅ Personalized Filters         | Filters based on user's conditions (e.g., diabetes, gluten allergy, vegan) |
| 🔄 Healthier Alternatives      | Suggests similar but healthier options                                      |
| 🎯 Mood-Based Recommendations | Suggests food based on user's mood (e.g., tired, happy, stressed)          |
| 🔐 Authentication              | Firebase Auth for sign in/up (Email + Google)                               |
| 🧑‍💼 User Profiles              | Custom diet preferences, allergies, and saved scans                         |
| 📈 History Page                | Tracks all previously scanned products                                     |

---

## 🚧 How It Works

1. **Scan Product**: User scans any food item via barcode or QR.
2. **Fetch & Analyze**: Product info is fetched from **OpenFoodFacts API**.
3. **Filter & Score**: Based on user's profile, it highlights good/bad ingredients.
4. **Suggest Better**: Displays healthier product alternatives (if available).
5. **Save to History**: Every scanned product is stored in user's history.

---

## 🔧 Tech Stack

| Tool/Platform | Purpose |
|---------------|---------|
| 🧩 Flutter     | Cross-platform mobile development |
| 🔥 Firebase    | Auth, Firestore, Cloud Functions |
| 🌐 OpenFoodFacts API | Product database |
| 📷 ML Kit / Camera | Barcode scanner |
| 🎨 Figma       | UI/UX prototyping |
| ☁️ Cloud Functions (optional) | Data enrichment, product scoring logic |

---

## 📸 UI Snapshots *(Replace with your real screenshots)*

| Home | Scanner | Product Details | History |
|------|---------|------------------|---------|
| ![Home](assets/screens/home.png) | ![Scanner](assets/screens/scan.png) | ![Details](assets/screens/details.png) | ![History](assets/screens/history.png) |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio or VSCode
- Firebase project setup

### Steps

```bash
# Clone the repo
git clone https://github.com/Rathod-Kuldeepsingh/Biterightapp.git
cd Biterightapp

# Install dependencies
flutter pub get

# Run the app
flutter run





---

### ✅ What You Can Do Now:
1. Create a file named `README.md` in the root of your `Biterightapp` project.
2. Paste the above content.
3. Replace the following:
   - Screenshot image paths.
   - Your actual **LinkedIn**, **email**, and **Firebase** setup notes.
   - Optional: Add demo video GIF or YouTube link.

---

Let me know if you want:
- PDF version of this README
- HTML version for a portfolio website
- Auto-push this to your GitHub repo

I'm here to help!

