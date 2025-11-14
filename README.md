# Agrivision-Milestone-2-
 Initial Code Structure (stubs, modules)
# 🌿 Crop Disease Analyzer App

This project is a mobile application designed to help users (e.g., farmers) diagnose potential diseases in their crops by analyzing images. It utilizes a **TensorFlow Lite (TFLite)** model for disease prediction and incorporates various services for user management, historical data, and weather-based risk alerts.

---

## 🚀 Features

The application is structured into several key components:

* **Image Analysis:** Capture or select a crop image and run it through a machine learning model for immediate disease prediction.
* **Result Display:** View detailed analysis results, including the predicted disease, relevant information, and treatment suggestions.
* **User Authentication (Stub):** Secure login and user profile management.
* **History Tracking (Stub):** Save and retrieve past analysis results.
* **Weather Risk Alerts (Stub):** Receive alerts based on local weather conditions that might indicate a high risk for specific diseases.
* **Chatbot Guidance (Stub):** A conversational interface for getting advice and answering crop-related questions.

---

## 🛠️ Project Structure

The project is divided into **Frontend (Flutter)** screens and services, and **Backend (FastAPI)** modules.

### 1. Frontend: Screens (`.dart` files)

| Screen | Purpose | Status |
| :--- | :--- | :--- |
| `home_screen.dart` | Main home/dashboard screen with navigation to other modules. | Implemented |
| `capture_screen.dart` | Main interface for capturing or selecting crop images and triggering analysis. | Implemented |
| `result_screen.dart` | Displays analysis results, including disease info and treatment. | Implemented |
| `login.dart` | User login/authentication screen. | **Stub** |
| `profile.dart` | User profile management screen. | **Stub** |
| `historylist_screen.dart` | Shows the user’s saved analysis history. | **Stub** |
| `weather_risk_alerts.dart` | Shows weather-based alerts for potential disease risks. | **Stub** |
| `chatbot_screen.dart` | UI for the chatbot feature. | **Stub** |

### 2. Frontend: Services (`.dart` files)

| Service | Purpose | Status |
| :--- | :--- | :--- |
| `model_service.dart` | Handles loading the TFLite model, preprocessing images, and predicting disease. | **Fully Implemented** |
| `user_service.dart` | Handles user account operations like login and profile management. | **Stub** |
| `storage_service.dart` | Manages storing images and results locally or in the cloud. | **Stub** |
| `history_service.dart` | Manages retrieval and storage of past analysis results. | **Stub** |
| `weather_service.dart` | Retrieves weather data and calculates disease risk. | **Stub** |
| `chatbot_service.dart` | Handles chatbot logic and responses. | **Stub** |

### 3. Frontend: Helper Directories

| Directory | Role | Example Use Case |
| :--- | :--- | :--- |
| `widgets/` | Reusable UI components | Disease card, custom button, chat bubble |
| `utils/` | Helper functions & shared logic | Date formatting, image preprocessing |
| `localization/` | Multi-language support | English/Arabic translations |

---

## 💻 Backend: FastAPI Modules

The backend is built using **FastAPI** to serve model predictions and other dynamic content.

| Module | Purpose | Implementation Status |
| :--- | :--- | :--- |
| **`main.py`** | Central FastAPI server that exposes endpoints for model, weather, and chatbot services. | **Stubbed:** All endpoints return placeholder responses. Ready for Flutter app to call. |
| **`model_training.py`** | Backend module for training, evaluating, and exporting the crop disease model. | **Stubbed:** Methods like `train_model`, `evaluate_model`, and `export_tflite_model` log actions but do not perform real training. |
| **`weather_service.py`** | Backend module to fetch weather info and calculate disease risk. | **Stubbed:** Methods like `fetch_weather_data` and `calculate_disease_risk` are placeholder functions. |
| **`chatbot_service.py`** | Backend module for chatbot responses. | **Stubbed:** The `get_response` method is a placeholder. |

---

## 🚦 Next Steps

The next major phases of development should focus on implementing the **stubbed** features:

1.  **Backend Integration:** Implement the real logic in `main.py`'s endpoints for weather and chatbot services.
2.  **User Authentication:** Fully implement `login.dart` and `user_service.dart` alongside the backend service.
3.  **Data Persistence:** Implement `storage_service.dart` and `history_service.dart` to manage user history.

Would you like me to generate a simple example for one of the currently implemented files, like `model_service.dart` or `capture_screen.dart`?
