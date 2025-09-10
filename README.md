# Pulmonosis
Pulmonosis is a mobile application designed to support non-invasive, rapid lung cancer diagnostics. It integrates IoT-based biosensors with real-time data monitoring and machine learning models to assist patients and healthcare providers in making informed decisions.

The app enables users to:
* View biosensor results transmitted from IoT devices.
* Fill out and submit LCSS (Lung Cancer Symptom Scale) questionnaires.
* Receive automated recommendations on whether medical referral is required.
* Schedule appointments with healthcare providers.
* Track and monitor personal health history over time.

## Technology Stack
* Flutter: Cross-platform mobile development (Android & iOS), ensuring smooth and responsive user experience.
* Machine learning: Logistic Regression model trained on hospital data to classify patient conditions and minimize false negatives.
* FastAPI: Provides RESTful endpoints to connect the Flutter front-end with the ML recommender system written in Python.
* Firebase: Real-time database for secure data storage and synchronization.

[![Image](https://github.com/user-attachments/assets/2c7a25a7-9812-495e-8e07-a80f12feace9)](https://youtu.be/h_Uf7FeEBQU?si=-MUUxXUWId3D5HUr "Demo")
