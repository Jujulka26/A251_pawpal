<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

$userid = $_POST['userid'];
$name = addslashes($_POST['name']);
$phone = addslashes($_POST['phone']);
$image = $_POST['image'];
if ($image == "NA") {
    $encodedimage = "NA";
} else {
    $encodedimage = base64_decode($_POST['image']);
}


$sqlupdateprofile = "
    UPDATE tbl_users 
    SET name='$name', phone='$phone'
    WHERE user_id='$userid'
";

try {
    if ($conn->query($sqlupdateprofile) === TRUE) {

        // ================= save image if not NA
        if ($encodedimage != "NA") {
            $path = "profiles/profile_" . $userid . ".jpg";
            file_put_contents($path, $encodedimage);
        }

        $response = array(
            'success' => true,
            'message' => 'Profile updated successfully'
        );
        sendJsonResponse($response);

    } else {
        $response = array(
            'success' => false,
            'message' => 'Profile update failed'
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

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
