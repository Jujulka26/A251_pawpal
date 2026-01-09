<?php
    header("Access-Control-Allow-Origin: *"); // running as chrome app

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        include 'dbconnect.php';

        $results_per_page = 10;
        if (isset($_GET['curpage'])) {
            $curpage = (int)$_GET['curpage'];
        } else {
            $curpage = 1;
        }
        $page_first_result = ($curpage - 1) * $results_per_page;

        // Base JOIN query for public listings
        $baseQuery = "
            SELECT 
                p.pet_id,
                p.user_id,
                p.pet_name,
                p.pet_type,
                p.pet_gender,
                p.pet_age,
                p.pet_health,
                p.category,
                p.description,
                p.image_paths,
                p.lat,
                p.lng,
                p.created_at,
                u.name,
                u.email,
                u.phone,
                u.reg_date
            FROM tbl_pets p
            JOIN tbl_users u ON p.user_id = u.user_id
            WHERE 1
        ";

        $sqlloadpets = $baseQuery;

        // Search logic (by pet name)
        if (isset($_GET['search']) && !empty($_GET['search'])) {
            $search = $conn->real_escape_string($_GET['search']);
            $sqlloadpets .= " AND p.pet_name LIKE '%$search%'";
        }

        // Filter logic (by pet type)
        if (isset($_GET['type']) && !empty($_GET['type'])) {
            $type = $conn->real_escape_string($_GET['type']);
            $sqlloadpets .= " AND p.pet_type = '$type'";
        }

        $sqlloadpets .= " ORDER BY p.pet_id DESC";

        // Execute query
        $result = $conn->query($sqlloadpets);
        $number_of_result = $result->num_rows;
        $number_of_page = ceil($number_of_result / $results_per_page);

        $sqlloadpets .= " LIMIT $page_first_result, $results_per_page";
        $result = $conn->query($sqlloadpets);

        if ($result && $result->num_rows > 0) {
            $petdata = array();
            while ($row = $result->fetch_assoc()) {
                $petdata[] = $row;
            }
            $response = array('success' => true, 'data' => $petdata,'numofpage'=>$number_of_page, 'numberofresult'=>$number_of_result);
            sendJsonResponse($response);
        } else {
            $response = array('success' => false, 'data' => null,'numofpage'=>$number_of_page, 'numberofresult'=>$number_of_result);
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
