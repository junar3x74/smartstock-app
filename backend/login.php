<?php
// Include database connection
include 'db.php';

// Set the content type to JSON
header('Content-Type: application/json');

// Start the session at the beginning
session_start();

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve and sanitize email and password from POST request
    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
    $password = $_POST['password'];

    // Check if email or password is empty
    if (empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'Email and password are required']);
        exit;
    }

    // Query to check if the email exists in the database
    $stmt = $conn->prepare("SELECT id, email, password, name, is_active, email_verified_at, created_at, updated_at FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user) {
        // Verify the password
        if (password_verify($password, $user['password'])) {
            // Store user data in session
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['user_email'] = $user['email'];

            // Prepare user profile data to return in the response
            $userProfile = [
                'name' => $user['name'],
                'email' => $user['email']
            ];

            // Check if the user is active
            if ($user['is_active'] == 1) {
                echo json_encode([
                    'success' => true,
                    'message' => 'Login successful',
                    'user' => $userProfile
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'User is not active']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid password']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'User not found']);
    }
} else {
    // Handle invalid request method
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>
