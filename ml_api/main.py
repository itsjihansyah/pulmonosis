from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import numpy as np
import joblib  # ganti ke joblib

# Init FastAPI
app = FastAPI()

# Load model & scaler
model = joblib.load("lcss_model.pkl")
scaler = joblib.load("scaler.pkl")

# Pydantic schema untuk request body
class SurveyRequest(BaseModel):
    answers: List[int]

# Endpoint predict
@app.post("/predict")
def predict(data: SurveyRequest):
    try:
        features = np.array(data.answers).reshape(1, -1)
        features_scaled = scaler.transform(features)
        proba = model.predict_proba(features_scaled)[0][1]
        prediction = int(proba >= 0.5)

        print("Raw:", features)
        print("Scaled:", features_scaled)
        print("Proba:", proba)

        return {
            "prediction": prediction,
            "probability": proba
        }
    except Exception as e:
        return {"error": str(e)}
