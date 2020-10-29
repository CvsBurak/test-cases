<?php
/**
 * Created by PhpStorm.
 * User: burakcavusoglu
 * Date: 26/04/2018
 * Time: 19:55
 */


if (empty($_GET["token"])) {

    echo 'Missing required information';
}

$token = htmlentities($_GET["token"]);

// secure way to build conn
$file = parse_ini_file("../../../GProject.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

require ("../secure/access.php");
$access = new access($host, $user, $pass, $name);
$access->connect();

// store in id the result of func
$id = $access->getUserID("emailTokens", $token);

if (empty($id["id"])) {

    echo 'User with this token is not found';
    return;
}


$result = $access->emailConfirmationStatus(1,$id["id"]);

if ($result) {

    // delete token from 'emailToken' db
    $access->deleteToken("emailTokens", $token);
    echo 'Thank you, Your E-mail confirmed..';
}


$access->disconnect();

?>