from flask import Flask, request, jsonify
from flask_cors import CORS  # Add this import
from google.cloud import firestore
import uuid
import os

# Set your Google Cloud credentials (update the path as needed)
# os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "path/to/your/service-account.json"

app = Flask(__name__)
CORS(app, origins=["https://customer-web-app-702586501583.us-central1.run.app"])  # Add this line
db = firestore.Client()
orders_collection = db.collection('orders')

@app.route('/order', methods=['POST'])
def place_order():
    data = request.get_json()
    product_id = data.get('product_id')
    if not product_id:
        return jsonify({'error': 'product_id is required'}), 400

    order_id = str(uuid.uuid4())
    order_data = {
        'order_id': order_id,
        'product_id': product_id,
        'status': 'placed'
    }
    orders_collection.document(order_id).set(order_data)
    return jsonify({'message': 'Order placed', 'order_id': order_id}), 201

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)