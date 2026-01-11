<?php
//error_reporting(0);
include_once("dbconnect.php");

$email = $_GET['email']; //email
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$credit = $_GET['credit']; 
$pet_id = $_GET['petid'];
$user_id = $_GET['userid'];


$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
$signed= hash_hmac('sha256', $signing, 'yourxsignature');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
    
        //update credit here
        $amount = $credit / 100;
        $sqlinsertdonation = "
        INSERT INTO tbl_donations (user_id, pet_id, donation_type, amount, description)
        VALUES ('$user_id', '$pet_id', 'Money', '$amount', 'NA')
    ";
        if ($conn->query($sqlinsertdonation) === TRUE){
             //print receipt for success transaction
            echo "
<html>
<head>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
<style>
  body {
    background-color: #f5f5f5;
    padding: 20px;
  }
  .receipt-card {
    max-width: 420px;
    margin: auto;
    background: #ffffff;
    border-radius: 8px;
    padding: 16px;
  }
  .receipt-title {
    text-align: center;
    font-weight: bold;
    margin-bottom: 16px;
  }
</style>
</head>

<body>
  <div class='receipt-card w3-card'>
    <div class='receipt-title'>Payment Receipt</div>

    <table class='w3-table w3-striped'>
      <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
      <tr><td><b>Name</b></td><td>$name</td></tr>
      <tr><td><b>Email</b></td><td>$email</td></tr>
      <tr><td><b>Phone</b></td><td>$phone</td></tr>
      <tr><td><b>Paid Amount</b></td><td>RM $amount</td></tr>
      <tr>
        <td><b>Status</b></td>
        <td class='".($paidstatus=="Success" ? "w3-text-green" : "w3-text-red")."'>
          $paidstatus
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
";
        }else{
             echo "
<html>
<head>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
<style>
  body {
    background-color: #f5f5f5;
    padding: 20px;
  }
  .receipt-card {
    max-width: 420px;
    margin: auto;
    background: #ffffff;
    border-radius: 8px;
    padding: 16px;
  }
  .receipt-title {
    text-align: center;
    font-weight: bold;
    margin-bottom: 16px;
  }
</style>
</head>

<body>
  <div class='receipt-card w3-card'>
    <div class='receipt-title'>Payment Receipt</div>

    <table class='w3-table w3-striped'>
      <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
      <tr><td><b>Name</b></td><td>$name</td></tr>
      <tr><td><b>Email</b></td><td>$email</td></tr>
      <tr><td><b>Phone</b></td><td>$phone</td></tr>
      <tr><td><b>Paid Amount</b></td><td>RM $amount</td></tr>
      <tr>
        <td><b>Status</b></td>
        <td class='".($paidstatus=="Success" ? "w3-text-green" : "w3-text-red")."'>
          $paidstatus
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
";
        }
    }
    else 
    {
        //print receipt for failed transaction
        echo "
<html>
<head>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
<style>
  body {
    background-color: #f5f5f5;
    padding: 20px;
  }
  .receipt-card {
    max-width: 420px;
    margin: auto;
    background: #ffffff;
    border-radius: 8px;
    padding: 16px;
  }
  .receipt-title {
    text-align: center;
    font-weight: bold;
    margin-bottom: 16px;
  }
</style>
</head>

<body>
  <div class='receipt-card w3-card'>
    <div class='receipt-title'>Payment Receipt</div>

    <table class='w3-table w3-striped'>
      <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
      <tr><td><b>Name</b></td><td>$name</td></tr>
      <tr><td><b>Email</b></td><td>$email</td></tr>
      <tr><td><b>Phone</b></td><td>$phone</td></tr>
      <tr><td><b>Paid Amount</b></td><td>RM $amount</td></tr>
      <tr>
        <td><b>Status</b></td>
        <td class='".($paidstatus=="Success" ? "w3-text-green" : "w3-text-red")."'>
          $paidstatus
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
";
    }
}

?>