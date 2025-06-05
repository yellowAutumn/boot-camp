// Replace these with your actual API endpoints as needed

export async function fetchProducts() {
  // Return mock products for local testing
  return [
    { id: 1, name: "Product A", price: 10.99 },
    { id: 2, name: "Product B", price: 19.99 },
    { id: 3, name: "Product C", price: 5.49 },
  ];
}

export async function orderProduct(productId) {
  // Return mock order confirmation
  return { id: Math.floor(Math.random() * 10000), productId };
}