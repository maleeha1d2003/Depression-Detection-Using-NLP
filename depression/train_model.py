import os
import pandas as pd
import numpy as np
import joblib
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from custom_transformers import SentimentExtractor, CombineFeatures
from scipy.sparse import hstack
from textblob import TextBlob
import nltk

nltk.download('brown')
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')
nltk.download('wordnet')

df = pd.read_csv(r"C:\Users\Aqsa\Desktop\6 semester\IDS\Mental-Health-Twitter.csv")

tfidf = TfidfVectorizer(max_features=10000, ngram_range=(1,2))
sentiment = SentimentExtractor()

pipeline = Pipeline([
    ('features', CombineFeatures(tfidf=tfidf, sentiment=sentiment)),
    ('classifier', LogisticRegression(max_iter=1000, class_weight='balanced'))
])

X = df['post_text']
y = df['label']

pipeline.fit(X, y)
print("Pipeline trained successfully!")

def predict_with_sentiment_override(pipeline, posts, threshold=0.3):
    """
    Predict depression using the pipeline.
    Overrides prediction to 'Not Depressed' if sentiment > threshold.
    """
    predictions = pipeline.predict(posts)
    probabilities = pipeline.predict_proba(posts)[:, 1]

    results = []
    for post, pred, prob in zip(posts, predictions, probabilities):
        sentiment_score = TextBlob(post).sentiment.polarity
        if sentiment_score > threshold:  # strong positive sentiment
            pred = 0  # mark as Not Depressed
            prob = max(prob, 1 - sentiment_score)
        label = "Depressed" if pred == 1 else "Not Depressed"
        results.append((post, label, prob, sentiment_score))
    return results

new_posts = [
    "I feel happy today!",
    "Feeling very sad...",
    "Had a great day with my friends, feeling happy!",
    "I feel so sad and hopeless today..."
]

results = predict_with_sentiment_override(pipeline, new_posts)
for post, label, prob, sentiment in results:
    print(f"Post: {post}\nPrediction: {label}, Probability: {prob:.2f}, Sentiment: {sentiment:.2f}\n")

os.makedirs("models", exist_ok=True)
joblib.dump(pipeline, "models/depression_detection_pipeline_sentiment_override.joblib")
print("Pipeline saved successfully at 'models/depression_detection_pipeline_sentiment_override.joblib'")