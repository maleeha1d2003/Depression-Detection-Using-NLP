from flask import Flask, request, jsonify
import joblib
from flask_cors import CORS 
from custom_transformers import SentimentExtractor, CombineFeatures

app = Flask(__name__)
CORS(app)  

model_path = "models/depression_detection_pipeline_sentiment_override.joblib"
pipeline = joblib.load(model_path)
print("Pipeline loaded successfully!")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    if not data or "posts" not in data:
        return jsonify({"error": "No posts provided"}), 400
    
    posts = data["posts"]

    if isinstance(posts, str):
        posts = [posts]
    elif not isinstance(posts, list):
        return jsonify({"error": "Posts must be a string or list of strings"}), 400
    predictions = pipeline.predict(posts)
    probabilities = pipeline.predict_proba(posts)[:, 1]

    threshold = 0.7

    results = []
    for post, prob in zip(posts, probabilities):
        pred_label = "Depressed" if prob > threshold else "Not Depressed"
        results.append({
            "post": post,
            "prediction": pred_label,
            "probability": float(prob)
        })

    return jsonify(results)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)