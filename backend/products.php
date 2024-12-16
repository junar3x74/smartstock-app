<?php
error_reporting(E_ALL); 
ini_set('display_errors', 1); // Enable error display for debugging

include('db.php');

// Check the connection to the database
if (!$conn) {
    echo json_encode(['error' => 'Database connection failed: ' . mysqli_connect_error()]);
    exit;
}

// Set content type to JSON
header('Content-Type: application/json');

// Query to fetch product details along with category name and product image
$query = "SELECT p.id, p.product_name, p.product_quantity, p.product_cost, p.product_price, p.product_stock_alert, 
                 p.created_at, p.updated_at, c.category_name, m.file_name AS product_image
          FROM products p
          LEFT JOIN categories c ON p.category_id = c.id
          LEFT JOIN media m ON m.model_type = 'product' AND m.model_id = p.id AND m.collection_name = 'product_images'"; 

// Execute the query
$result = $conn->query($query);

// Check for query execution errors
if (!$result) {
    echo json_encode(['error' => 'Query failed: ' . $conn->error]);
    exit;
}

$products = [];
if ($result->num_rows > 0) {
    // Fetch results
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
} else {
    // If no products are found, return an empty array
    $products = [];
}

// Return products as JSON
echo json_encode($products);

// Close the database connection
closeConnection();
?>
