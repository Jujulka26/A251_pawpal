<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}
	if (!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['phone']) || !isset($_POST['password'])) {
		http_response_code(400);
		echo json_encode(array('error' => 'Bad Request'));
		exit();
	}

    $name = $_POST['name'];
	$email = $_POST['email'];
	$phone = $_POST['phone'];
	$password = $_POST['password'];
	$hashedpassword = sha1($password);
	
	// Check if email already exists
	$sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
    $result = $conn->query($sqlcheckmail);
	if ($result->num_rows > 0){
		$response = array('success' => false, 'message' => 'Email already registered');
		sendJsonResponse($response);
		exit();
	}

	// Insert new user into database
	$sqlregister = "INSERT INTO `tbl_users`(`name`, `email`, `phone`, `password`) VALUES ('$name','$email','$phone','$hashedpassword')";
	try{
		if ($conn->query($sqlregister) === TRUE){
			$response = array('success' => true, 'message' => 'User registered successfully');
			sendJsonResponse($response);
		}else{
			$response = array('success' => false, 'message' => 'User registration failed');
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