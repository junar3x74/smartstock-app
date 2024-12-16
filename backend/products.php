<?php
include('db.php');

// Fetch products from the database
$query = "SELECT * FROM products";
$result = $conn->query($query);

$products = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
}

// Return products as JSON
echo json_encode($products);

closeConnection();
?>
