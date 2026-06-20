import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import StandardScaler
from scipy.sparse import hstack
from textblob import TextBlob

class SentimentExtractor(BaseEstimator, TransformerMixin):
    def fit(self, X, y=None):
        return self
    def transform(self, X):
        sentiment_scores = [TextBlob(str(text)).sentiment.polarity for text in X]
        return np.array(sentiment_scores).reshape(-1, 1)

class CombineFeatures(BaseEstimator, TransformerMixin):
    def __init__(self, tfidf, sentiment):
        self.tfidf = tfidf
        self.sentiment = sentiment
        self.scaler = StandardScaler()
    def fit(self, X, y=None):
        self.tfidf.fit(X)
        sentiment_features = self.sentiment.transform(X)
        self.scaler.fit(sentiment_features)
        return self
    def transform(self, X):
        if isinstance(X, str):
            X = [X]
        tfidf_features = self.tfidf.transform(X)
        sentiment_features = self.scaler.transform(self.sentiment.transform(X))
        return hstack([tfidf_features, sentiment_features])


