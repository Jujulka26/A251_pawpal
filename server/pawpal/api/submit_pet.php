<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}

	$user_id = $_POST['user_id']; 
    $pet_name = addslashes($_POST['pet_name']);
    $pet_type = $_POST['pet_type'];
    $pet_gender = $_POST['pet_gender'];
    $pet_age = $_POST['pet_age'];   
    $pet_health = $_POST['pet_health'];
    $category = $_POST['category'];
    $description = addslashes($_POST['description']);
    $lat = $_POST['lat'];
    $lng = $_POST['lng'];

    $filenames = array();
    $decodedimages = array();
    if (isset($_POST['image_paths'])) {
        $image_paths = $_POST['image_paths'];
        foreach ($image_paths as $index => $base64_image) {
            $filename = "pet_" . $user_id . "_" . uniqid() . "_" . $index . ".jpg";
            $filenames[] = $filename;
            $decodedimages[] = base64_decode($base64_image);
        }
    }

    $db_paths = array();
    foreach($filenames as $fname) {
        $db_paths[] = "uploads/" . $fname;
    }
    $image_paths_string = implode(",", $db_paths);

	// Insert new service into database
	$sqlinsertservice = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `pet_gender`, `pet_age`, `pet_health`, `category`, `description`, `image_paths`, `lat`, `lng`) 
	VALUES ('$user_id','$pet_name','$pet_type','$pet_gender','$pet_age','$pet_health','$category','$description', '$image_paths_string', '$lat', '$lng')";
	try{
		if ($conn->query($sqlinsertservice) === TRUE){
            for ($i = 0; $i < count($filenames); $i++) {
                $filename = $filenames[$i];
                $decodedImage = $decodedimages[$i];
                file_put_contents("uploads/" . $filename, $decodedImage);
            }

			$response = array('success' => true, 'message' => 'Pet submitted successfully');
			sendJsonResponse($response);
		}else{
			$response = array('success' => false, 'message' => 'Pet not submitted');
			sendJsonResponse($response);
		}
        
	}catch(Exception $e){
		$response = array('success' => false, 'message' => $e->getMessage());
		sendJsonResponse($response);
	}

    //	function to send json response	
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>