<?php
/**
 * Created by PhpStorm.
 * User: burakcavusoglu
 * Date: 26/04/2018
 * Time: 20:20
 */


class email {


    function generateToken($length) {

        $characters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";

        $charactersLenght = strlen($characters);

        $token = '';

        for ($i = 0; $i < $length; $i++) {

            $token .= $characters[rand(0,$charactersLenght-1)];


        }

        return $token;
    }

    function confirmationTemplate() {

        $file = fopen("templates/cofirmationTemplate.html" , "r" or die("Unable to open file"));

        $template = fread($file, filesize("templates/cofirmationTemplate.html"));

        fclose($file);

        return $template;

    }

    function sendEmail($details) {

        $subject = $details["subject"];
        $to = $details["to"];
        $fromName = $details["fromName"];
        $fromEmail = $details["fromEmail"];
        $body = $details["body"];

        $headers = "MIME-Version: 1.0" . "\r\n";
        $headers .= "Content-type:text/html;content=UTF-8" . "\r\n";
        $headers .= "From: " . $fromName . " <" . $fromEmail . ">" . "\r\n";


        mail($to, $subject, $body, $headers);

    }

}





?>