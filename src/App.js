import React, { useEffect, useState } from "react";
import { fetchProducts, orderProduct } from "./api";

function App() {
  const [products, setProducts] = useState([]);
  const [message, setMessage] = useState("");

  useEffect(() => {
    fetchProducts().then(setProducts);
  }, []);

  const handleOrder = async (id) => {
    const result = await orderProduct(id);
    setMessage(`Order placed! Order ID: ${result.id} for product ${id}`);
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>Welcome to E-Commerce Website</h1>
      <h2>Available Products</h2>
      <table border="1" cellPadding="8" cellSpacing="0">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Price ($)</th>
            <th>Order</th>
          </tr>
        </thead>
        <tbody>
          {products.map((p) => (
            <tr key={p.id}>
              <td>{p.id}</td>
              <td>{p.name}</td>
              <td>{p.cost}</td>
              <td>
                <button onClick={() => handleOrder(p.id)}>Order</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {message && (
        <div style={{ marginTop: 20, color: "green" }}>
          {message}
        </div>
      )}
    </div>
  );
}

export default App;
