<?php
/**
 * Created by PhpStorm.
 * User: burakcavusoglu
 * Date: 30/04/2018
 * Time: 00:03
 */


if (empty($_POST["id"])) {

    $returnArray["message"] = "Missing required information";
    return;
}

$id = htmlentities($_POST["id"]);

$folder = "/Applications/MAMP/htdocs/GProject/ava/" . $id;

if (!file_exists($folder)) {

    mkdir($folder, 0777, true);
}

$folder = $folder . "/" . basename($_FILES["file"] ["name"]);

if (move_uploaded_file($_FILES["file"] ["tmp_name"], $folder)) {

    $returnArray["status"] = "200";
    $returnArray["message"] = "The file has been uploaded";
} else {
    $returnArray["status"] = "300";
    $returnArray["message"] = "Error while uploading";
}

$file = parse_ini_file("../../GProject.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

// include access.php to call func from access.php file
require ("secure/access.php");
$access = new access($host, $user, $pass, $name);
$access->connect();

// save path to uploaded file in DB
$path = "http://192.168.1.28:8888/GProject/ava/" . $id . "/ava.jpg";
$access->updateAvaPath($path, $id);

$user = $access->selectUserViaID($id);

$returnArray["id"] = $user["id"];
$returnArray["username"] = $user["username"];
$returnArray["fullname"] = $user["fullname"];
$returnArray["email"] = $user["email"];
$returnArray["ava"] = $user["ava"];

$access->disconnect();

echo json_encode($returnArray);





?>