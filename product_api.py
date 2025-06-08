from google.cloud import firestore, pubsub_v1
from flask import Flask, jsonify
from flask_cors import CORS  # Add this import
import os
import json
import uuid
from datetime import datetime


app = Flask(__name__)
db = firestore.Client()
PRODUCTS_COLLECTION = "products"
CORS(app, origins=["https://customer-web-app-702586501583.us-central1.run.app"])  # Add this line


# Pub/Sub setup
PUBSUB_TOPIC = os.environ.get("PUBSUB_TOPIC", "projects/pr-db-fn-1/topics/product-events")
publisher = pubsub_v1.PublisherClient()


@app.route('/products', methods=['GET'])
def get_all_products():
    products_ref = db.collection(PRODUCTS_COLLECTION)
    docs = products_ref.stream()
    products = []
    for doc in docs:
        data = doc.to_dict()
        product = {
            "id": doc.id,
            "name": data.get("name"),
            "cost": data.get("cost")
        }
        products.append(product)

    # Publish event to Pub/Sub
    event = {
        "event_id": str(uuid.uuid4()),
        "event_type": "get_all_products",
        "user_id": None,  # or set to the user if available
        "event_timestamp": datetime.utcnow().isoformat() + "Z",
        "event_data": json.dumps({"products_count": len(products)})
    }
    publisher.publish(PUBSUB_TOPIC, json.dumps(event).encode("utf-8"))
    print(f"Published event: {event}")
    return jsonify(products), 200

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
