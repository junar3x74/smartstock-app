<?php
include 'config.php';  // Database connection config

/// Create a connection to the database
$dsn = "mysql:host=$host;dbname=$dbname;charset=$charset";
try {
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    exit;
}

// Check the request method (should be POST)
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Query to get the user details from the users table
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email LIMIT 1");
    $stmt->bindParam(':email', $email, PDO::PARAM_STR);
    $stmt->execute();

    // Fetch the user row
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // Check if the user exists and the password is correct
    if ($user && password_verify($password, $user['password'])) {
        if ($user['is_active'] == 1) {
            // If the user is active, return success
            echo json_encode(["success" => true, "message" => "Login successful"]);
        } else {
            // User is not active
            echo json_encode(["success" => false, "message" => "Account is not active"]);
        }
    } else {
        // Incorrect login details
        echo json_encode(["success" => false, "message" => "Invalid email or password"]);
    }
}
?>
