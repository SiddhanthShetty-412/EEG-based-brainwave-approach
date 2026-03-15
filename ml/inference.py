import pickle
from pathlib import Path


MODEL_PATH = Path(__file__).resolve().parent / "artifacts" / "random_forest_model.pkl"

# Lazy load model so importing the module doesn't crash the app if dependencies
# or the model file are missing. Capture load errors for clearer diagnostics.
model = None
_model_load_error = None

def _load_model():
    global model, _model_load_error
    if model is not None or _model_load_error is not None:
        return
    try:
        with open(MODEL_PATH, "rb") as f:
            model = pickle.load(f)
    except Exception as e:
        model = None
        _model_load_error = str(e)


def is_model_available():
    _load_model()
    return model is not None


def get_model_error():
    _load_model()
    return _model_load_error


def predict_from_features(features):
    _load_model()
    if model is None:
        raise RuntimeError(f"Model not available: {get_model_error()}")

    prediction = int(model.predict(features)[0])

    if hasattr(model, "predict_proba"):
        probability = float(model.predict_proba(features)[0][1])
    else:
        probability = 0.0

    label = "MDD" if prediction == 1 else "Healthy"

    return {
        "label": label,
        "probability": probability,
        "prediction": prediction,
    }


def predict_from_edf(edf_path):
    try:
        from .preprocessing import extract_features_from_edf, summarize_features
    except Exception as e:
        raise RuntimeError(f"Failed to import preprocessing: {e}")

    features = extract_features_from_edf(edf_path)
    pred = predict_from_features(features)
    summary = summarize_features(features)

    return {
        "label": pred["label"],
        "probability": pred["probability"],
        "prediction": pred["prediction"],
        "features": features,
        "summary": summary,
    }