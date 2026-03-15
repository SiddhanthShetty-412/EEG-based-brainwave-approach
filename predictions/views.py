"""
        Version 1
from django.shortcuts import render

# Create your views here.
# predictions/views.py
from django.shortcuts import render
from .forms import FeatureInputForm
from ml.inference import parse_features_text, predict_one, EXPECTED_FEATURES


def home(request):
    form = FeatureInputForm()
    prediction_label = None
    prediction_text = None
    probability = None
    error = None
    n_received = None

    if request.method == "POST":
        form = FeatureInputForm(request.POST)
        if form.is_valid():
            features_text = form.cleaned_data["features_text"]
            try:
                features = parse_features_text(features_text)
                n_received = len(features)

                pred, prob = predict_one(features)

                prediction_label = pred
                prediction_text = "MDD" if pred == 1 else "Healthy"
                probability = prob

            except Exception as e:
                error = str(e)

    return render(
        request,
        "predictions/index.html",
        {
            "form": form,
            "prediction_label": prediction_label,
            "prediction_text": prediction_text,
            "probability": probability,
            "error": error,
            "expected_features": EXPECTED_FEATURES,
            "n_received": n_received,
        },
    )

    

        Version 2
from django.shortcuts import render
from .forms import CSVUploadForm
from ml.csv_utils import read_csv_features
from ml.inference import predict_one, EXPECTED_FEATURES


def home(request):
    form = CSVUploadForm()
    prediction_label = None
    prediction_text = None
    probability = None
    error = None
    n_received = None

    if request.method == "POST":
        form = CSVUploadForm(request.POST, request.FILES)

        if form.is_valid():
            csv_file = form.cleaned_data["csv_file"]
            try:
                features = read_csv_features(csv_file)
                n_received = len(features)

                pred, prob = predict_one(features)

                prediction_label = pred
                prediction_text = "MDD" if pred == 1 else "Healthy"
                probability = prob

            except Exception as e:
                error = str(e)

    return render(
        request,
        "predictions/index.html",
        {
            "form": form,
            "prediction_label": prediction_label,
            "prediction_text": prediction_text,
            "probability": probability,
            "error": error,
            "expected_features": EXPECTED_FEATURES,
            "n_received": n_received,
        },
    )


"""
"""
import os
from django.shortcuts import render
from .forms import EDFUploadForm

from ml.preprocessing import extract_features_from_edf
from ml.inference import predict_from_features


UPLOAD_DIR = "uploads"


def index(request):

    result = None

    if request.method == "POST":

        form = EDFUploadForm(request.POST, request.FILES)

        if form.is_valid():

            edf_file = request.FILES["edf_file"]

            file_path = os.path.join(UPLOAD_DIR, edf_file.name)

            # Save file
            with open(file_path, "wb+") as f:
                for chunk in edf_file.chunks():
                    f.write(chunk)

            # Extract features
            features = extract_features_from_edf(file_path)

            # Predict
            result = predict_from_features(features)

    else:
        form = EDFUploadForm()

    return render(request, "predictions/index.html", {
        "form": form,
        "result": result
    })
"""
from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from .forms import EDFUploadForm

from ml.models import EEGUpload, PredictionResult

# Import ML predictor lazily inside views to avoid hard dependency failures



def index(request):
    result = None
    upload_id = None
    error = None
    form = EDFUploadForm()

    if request.method == "POST":
        form = EDFUploadForm(request.POST, request.FILES)

        if form.is_valid():
            edf_file = request.FILES.get("edf_file")

            if not edf_file:
                error = "No EDF file was uploaded."
            else:
                upload = EEGUpload.objects.create(
                    file=edf_file,
                    original_name=edf_file.name,
                    status="uploaded",
                )

                try:
                    try:
                        from ml.inference import predict_from_edf, is_model_available, get_model_error
                    except Exception:
                        predict_from_edf = None
                        is_model_available = lambda: False
                        get_model_error = lambda: "import failed"

                    if not is_model_available() or predict_from_edf is None:
                        raise RuntimeError(f"ML model not available: {get_model_error()}")
                    pred = predict_from_edf(upload.file.path)

                    PredictionResult.objects.update_or_create(
                        upload=upload,
                        defaults={
                            "predicted_label": pred["label"],
                            "prediction_int": pred["prediction"],
                            "probability": pred["probability"],
                            "features_json": pred["summary"],
                        }
                    )

                    upload.status = "processed"
                    upload.save()

                    upload_id = upload.id
                    result = {
                        "label": pred["label"],
                        "probability": pred["probability"],
                        "prediction": pred["prediction"],
                        "summary": pred["summary"],
                    }

                except Exception as e:
                    upload.status = "failed"
                    upload.save()
                    error = str(e)

    return render(
        request,
        "predictions/index.html",
        {
            "form": form,
            "result": result,
            "upload_id": upload_id,
            "error": error,
        },
    )


@csrf_exempt
def api_upload(request):
    # Simple CORS preflight handling for local dev
    if request.method == "OPTIONS":
        response = HttpResponse()
        response["Access-Control-Allow-Origin"] = "*"
        response["Access-Control-Allow-Methods"] = "POST, OPTIONS"
        response["Access-Control-Allow-Headers"] = "Content-Type"
        return response

    if request.method != "POST":
        return JsonResponse({"error": "Only POST allowed"}, status=405)

    edf_file = request.FILES.get("edf_file")

    if not edf_file:
        return JsonResponse({"error": "No EDF file uploaded."}, status=400)

    # Save upload record
    upload = EEGUpload.objects.create(
        file=edf_file,
        original_name=edf_file.name,
        status="uploaded",
    )

        try:
            try:
                from ml.inference import predict_from_edf, is_model_available, get_model_error
            except Exception:
                predict_from_edf = None
                is_model_available = lambda: False
                get_model_error = lambda: "import failed"

            if not is_model_available() or predict_from_edf is None:
                raise RuntimeError(f"ML model not available: {get_model_error()}")

            pred = predict_from_edf(upload.file.path)

        PredictionResult.objects.update_or_create(
            upload=upload,
            defaults={
                "predicted_label": pred["label"],
                "prediction_int": pred["prediction"],
                "probability": pred["probability"],
                "features_json": pred["summary"],
            },
        )

        upload.status = "processed"
        upload.save()

        result = {
            "label": pred["label"],
            "probability": pred["probability"],
            "prediction": pred["prediction"],
            "summary": pred["summary"],
            "upload_id": upload.id,
        }

        response = JsonResponse({"result": result})
        response["Access-Control-Allow-Origin"] = "*"
        return response

    except Exception as e:
        upload.status = "failed"
        upload.save()
        response = JsonResponse({"error": str(e)}, status=500)
        response["Access-Control-Allow-Origin"] = "*"
        return response