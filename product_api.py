from flask import Flask, jsonify
from google.cloud import firestore
import os

app = Flask(__name__)
db = firestore.Client()
PRODUCTS_COLLECTION = "products"

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
    return jsonify(products), 200

# Cloud Run expects the app to listen on 0.0.0.0 and the port from $PORT
if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)