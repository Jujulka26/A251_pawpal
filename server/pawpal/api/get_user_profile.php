<?php
header("Access-Control-Allow-Origin: *"); // running as chrome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    if (!isset($_GET['userid'])) {
        $response = array(
            'success' => false,
            'message' => 'Bad Request',
            'data' => null
        );
        sendJsonResponse($response);
        exit();
    }

    $userid = $_GET['userid'];
    include 'dbconnect.php';

    $sqlgetuser = "
        SELECT 
            user_id,
            name,
            email,
            phone,
            reg_date
        FROM tbl_users
        WHERE user_id = '$userid'
    ";

    $result = $conn->query($sqlgetuser);

    if ($result && $result->num_rows > 0) {
        $userdata = array();
        while ($row = $result->fetch_assoc()) {
            $userdata[] = $row;
        }

        $response = array(
            'success' => true,
            'message' => 'Success',
            'data' => $userdata
        );
        sendJsonResponse($response);

    } else {
        $response = array(
            'success' => false,
            'message' => 'Invalid request',
            'data' => null
        );
        sendJsonResponse($response);
    }

} else {
    $response = array(
        'success' => false,
        'message' => 'Method Not Allowed',
        'data' => null
    );
    sendJsonResponse($response);
    exit();
}

// ---------- JSON RESPONSE ----------
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
