<?php
/**
 * Created by PhpStorm.
 * User: burakcavusoglu
 * Date: 27/04/2018
 * Time: 02:53
 */

if (empty($_REQUEST["username"]) || empty($_REQUEST["password"])) {

    $returnArray["status"] = "400";
    $returnArray["message"] = "Missing required information";
    echo json_encode($returnArray);
    return;
}

$username = htmlentities($_REQUEST["username"]);
$password = htmlentities($_REQUEST["password"]);



$file = parse_ini_file("../../GProject.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

// include access.php to call func from access.php file
require ("secure/access.php");
$access = new access($host, $user, $pass, $name);
$access->connect();


// Get user information
$user = $access->getUser($username);

if (empty($user)) {

    $returnArray["status"] = "403";
    $returnArray["message"] = "User is not found";
    echo json_encode($returnArray);
    return;
}

// Check validity of password
$secured_password = $user["password"];
$salt = $user["salt"];

if ($secured_password == sha1($password . $salt)) {

    $returnArray["status"] = "200";
    $returnArray["message"] = "Logged in succesfully";
    $returnArray["id"] = $user["id"];
    $returnArray["username"] = $user["username"];
    $returnArray["email"] = $user["email"];
    $returnArray["fullname"] = $user["fullname"];
    $returnArray["ava"] = $user["ava"];


} else {

    $returnArray["status"] = "403";
    $returnArray["message"] = "Wrong password";
}

$access->disconnect();

echo json_encode($returnArray);




?>