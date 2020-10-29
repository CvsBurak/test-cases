<?php
/**
 * Created by PhpStorm.
 * User: burakcavusoglu
 * Date: 26/04/2018
 * Time: 02:07
 */


if (empty($_REQUEST["username"]) || empty($_REQUEST["password"]) || empty($_REQUEST["email"]) || empty($_REQUEST["fullname"])) {
    $returnArray["status"] = "400";
    $returnArray["message"] = "Missing required information";
    echo json_encode($returnArray);
    return;
}

// Securing information and storing variables
$username = htmlentities($_REQUEST["username"]);
$password = htmlentities($_REQUEST["password"]);
$email = htmlentities($_REQUEST["email"]);
$fullname = htmlentities($_REQUEST["fullname"]);

// secure password
$salt = openssl_random_pseudo_bytes(20);
$secured_password = sha1($password . $salt);


$file = parse_ini_file("../../GProject.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

// include access.php to call func from access.php file
require ("secure/access.php");
$access = new access($host, $user, $pass, $name);
$access->connect();


$result = $access->registerUser($username, $secured_password, $salt, $email, $fullname);

// successfully registered
if ($result) {

    // get current registered user information and store in $user
    $user = $access->selectUser($username);

    // declare information to feedback to user of App as json
    $returnArray["status"] = "200";
    $returnArray["message"] = "Successfully registered";
    $returnArray["id"] = $user["id"];
    $returnArray["username"] = $user["username"];
    $returnArray["email"] = $user["email"];
    $returnArray["fullname"] = $user["fullname"];
    $returnArray["ava"] = $user["ava"];

    require ("secure/email.php");
    // store all class in email
    $email = new email();

    $token =  $email->generateToken(20);

    // save information in 'emailTokens' table
    $access->saveToken("emailTokens", $user["id"], $token);

    $details = array();
    $details["subject"] = "Email confirmation on GProject";
    $details["to"] = $user["to"];
    $details["fromName"] = "Burak Çavuşoğlu";
    $details["fromEmail"] = "brkcvs321@gmail.com";

    // access template file

    $template = $email->confirmationTemplate();

    // replace token from confirmationTemplate.html by $token and store in $template
    $template = str_replace("{roke}", $token, $template);

    $details["body"] = $template;

    $email->sendEmail($details);

} else {
    $returnArray["status"] = "400";
    $returnArray["message"] = "Could not register with provided infomraiton";
}


// STEP 5. Close connection
$access->disconnect();


// STEP 6. Json data
echo json_encode($returnArray);




?>