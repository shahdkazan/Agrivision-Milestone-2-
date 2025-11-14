from fastapi import FastAPI
from pydantic import BaseModel
from typing import Dict
from model_training import ModelTrainer
from weather_service import WeatherService
from chatbot_service import ChatbotService

app = FastAPI(title="AgriVision Backend")

# Instantiate services
model_trainer = ModelTrainer()
weather_service = WeatherService()
chatbot_service = ChatbotService()

# -------------------------------
# Request models
# -------------------------------
class TrainRequest(BaseModel):
    dataset_path: str

class EvaluateRequest(BaseModel):
    test_data_path: str

class ExportRequest(BaseModel):
    save_path: str

class WeatherRequest(BaseModel):
    location: str

class ChatRequest(BaseModel):
    message: str

# -------------------------------
# Model training endpoints
# -------------------------------
@app.post("/train_model")
def train_model(request: TrainRequest):
    model_trainer.train_model(request.dataset_path)
    return {"status": "Training started (stub)"}

@app.post("/evaluate_model")
def evaluate_model(request: EvaluateRequest):
    model_trainer.evaluate_model(request.test_data_path)
    return {"status": "Evaluation done (stub)"}

@app.post("/export_model")
def export_model(request: ExportRequest):
    model_trainer.export_tflite_model(request.save_path)
    return {"status": f"Model exported to {request.save_path} (stub)"}

# -------------------------------
# Weather service endpoints
# -------------------------------
@app.post("/weather")
def get_weather(request: WeatherRequest):
    weather_data = weather_service.fetch_weather_data(request.location)
    risk = weather_service.calculate_disease_risk(weather_data)
    return {"weather_data": weather_data, "disease_risk": risk}

# -------------------------------
# Chatbot endpoint
# -------------------------------
@app.post("/chat")
def chat(request: ChatRequest):
    response = chatbot_service.get_response(request.message)
    return {"response": response}
