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
    $motivation = addslashes($_POST['motivation'] ?? '');

    // INSERT ADOPTION REQUEST
    $sqlinsertadoption = "
        INSERT INTO tbl_adoptions (user_id, pet_id, motivation)
        VALUES ('$user_id', '$pet_id', '$motivation')
    ";

    try {
        if ($conn->query($sqlinsertadoption) === TRUE) {
            $response = array(
                'success' => true,
                'message' => 'Adoption request submitted successfully'
            );
            sendJsonResponse($response);
        } else {
            $response = array(
                'success' => false,
                'message' => 'Failed to submit adoption request'
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
