<?php
    $servername = "localhost";
    $username = "canortxw_junjeang";
    $password = "Arcobaleno@@7";
    $dbname = "canortxw_junjeang_pawpal_db";
    // create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>