<?php
    header("Access-Control-Allow-Origin: *");
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        http_response_code(405);
        echo json_encode(array('error' => 'Method Not Allowed'));
        exit();
    }

    // REQUIRED FIELDS
    $user_id = $_POST['user_id'] ?? '';
    $pet_id = $_POST['pet_id'] ?? '';
    $donation_type = $_POST['donation_type'] ?? '';
    $amount = $_POST['amount'] ?? '';
    $description = addslashes($_POST['description'] ?? '');

    // INSERT ADOPTION REQUEST
    $sqlinsertdonation = "
        INSERT INTO tbl_donations (user_id, pet_id, donation_type, amount, description)
        VALUES ('$user_id', '$pet_id', '$donation_type', '$amount', '$description')
    ";

    try {
        if ($conn->query($sqlinsertdonation) === TRUE) {
            $response = array(
                'success' => true,
                'message' => 'Donation submitted successfully'
            );
            sendJsonResponse($response);
        } else {
            $response = array(
                'success' => false,
                'message' => 'Failed to submit donation'
            );
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        $response = array(
            'success' => false,
            'message' => $e->getMessage()
        );
        sendJsonResponse($response);
    }

    // FUNCTION TO SEND JSON RESPONSE
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>
