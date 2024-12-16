<?php
include('config.php');

// Helper function to close database connection
function closeConnection() {
    global $conn;
    $conn->close();
}
?>
