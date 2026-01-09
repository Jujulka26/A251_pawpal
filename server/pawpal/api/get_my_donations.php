<?php
header("Access-Control-Allow-Origin: *");

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['userid'])) {
    include 'dbconnect.php';

    $userid = $_GET['userid'];

    $query = "
        SELECT 
            d.donation_id,
            d.user_id,
            d.pet_id,
            p.pet_name,
            d.donation_type,
            d.amount,
            d.description,
            d.donation_date
        FROM tbl_donations d
        JOIN tbl_pets p ON d.pet_id = p.pet_id
        WHERE d.user_id = '$userid'
        ORDER BY d.donation_date DESC
    ";

    $result = $conn->query($query);

    if ($result && $result->num_rows > 0) {
        $donationdata = array();
        while ($row = $result->fetch_assoc()) {
            $donationdata[] = $row;
        }
        $response = array(
            'success' => true,
            'data' => $donationdata
        );
        sendJsonResponse($response);
    } else {
        $response = array(
            'success' => false,
            'data' => null
        );
        sendJsonResponse($response);
    }

} else {
    $response = array('success' => false);
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
