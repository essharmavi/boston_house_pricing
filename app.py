import pickle
from flask import Flask, request, jsonify, app, url_for, render_template
from sklearn.preprocessing import StandardScaler
import numpy as np
import pandas as pd

app = Flask(__name__)
model = pickle.load(open("boston_housing_model.pkl", "rb"))
scaler = pickle.load(open("scaler_boston_housing_model.pkl", "rb"))

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/predict_api', methods=['POST'])
def predict_api():
    data = request.json['data']
    print(data)
    new_data = scaler.transform(np.array(list(data.values())).reshape(1, -1))
    output = model.predict(new_data)
    print(output[0])
    return jsonify(output[0])

@app.route('/predict', methods=['POST'])
def predict():
    data = [float(x) for x in request.form.values()]
    final_input = scaler.transform(np.array(data).reshape(1, -1))
    output = model.predict(final_input)
    return render_template("home.html", prediction_text=f"The predicted house price is {output[0]}")

if __name__ == "__main__":
    app.run(debug=True)