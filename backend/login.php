<?php
// Include database connection
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get email and password from POST request
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Query to check if the email and password match
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user) {
        // Check if password matches
        if (password_verify($password, $user['password'])) {
            echo json_encode(['success' => true, 'message' => 'Login successful']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid password']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'User not found']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>
