<?php
// Database configuration
$host = "localhost"; // Change to your database host
$username = "root";  // Your database username
$password = "";      // Your database password
$dbname = "smartstock_db"; // The name of your database

// Create a connection to the database
$conn = new mysqli($host, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
