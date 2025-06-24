# 🚚 Driver App – Proof of Delivery (POD)

An **offline-first Flutter app** built for delivery drivers and couriers to collect and manage Proof of Delivery (POD) data in the field. This app allows users to capture delivery details, take photos, and store data locally when offline — with the ability to manually sync once reconnected to the internet.


## 📋 Description

**Driver App** enables seamless, secure delivery confirmation workflows in areas with unreliable or no internet. With features like digital signature capture, photo proof, and manual sync, it is ideal for last-mile delivery services, field technicians, or logistics providers.


## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Offline Local Storage:** Drift (with SQLite), Shared Preferences
- **Authentication:** Firebase Authentication
- **Database (Cloud):** Firebase Firestore
- **Media Storage:** Firebase Storage
- **Device Features:**
  - Image Capture: `image_picker`
  - Network Monitoring: `connectivity_plus`
  - File & URL Sharing: `share_plus`, `url_launcher`
- **Data Sync & HTTP Requests:** `http`
- **Database Utilities:** Drift, FFI, SQFlite
- **Build Tools:** Drift Dev, Build Runner
- **Design Assets:** Cupertino Icons, Material Design


## 📱 Features

- ✅ **Offline-First Architecture**  
  Capture and store delivery data while offline using a local database.

- 📸 **Photo Capture**  
  Take photos of delivered items for digital proof.

- 📝 **Digital Delivery Details**  
  Record delivery info including customer name, time, comments, and location.

- 🔁 **Manual Sync**  
  Sync unsynced records to the cloud once internet access is available.

- 🔒 **Secure & Lightweight**  
  Designed for low-resource environments with secure local data storage.

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK 3.5.0+
- Android Studio or VS Code with Flutter plugin
- Firebase project (Firestore + Auth + Storage)

### Installation

```bash
git clone https://github.com/jvashiri/proof-of-delivery-app.git
cd driver_app
flutter pub get
flutter run
💡 Planned Improvements
🔐 Role-based user authentication

📍 GPS location tagging with delivery

✍️ Signature capture pad

🧾 Generate & share delivery receipts (PDF)

🕵️ Admin dashboard for tracking deliveries

