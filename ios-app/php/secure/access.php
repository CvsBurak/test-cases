<?php
/**
 * Created by PhpStorm.
 * User: burakcavusoglu
 * Date: 26/04/2018
 * Time: 01:55
 */


class access
{

    // connection global variables
    var $host = null;
    var $user = null;
    var $pass = null;
    var $name = null;
    var $conn = null;
    var $result = null;


    // constructing class
    function __construct($dbhost, $dbuser, $dbpass, $dbname)
    {

        $this->host = $dbhost;
        $this->user = $dbuser;
        $this->pass = $dbpass;
        $this->name = $dbname;

    }


    // connection function
    public function connect()
    {

        // establish connection and store it in $conn
        $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->name);

        // if error
        if (mysqli_connect_errno()) {
            echo 'Could not connect to database';
        }


        // support all languages
        $this->conn->set_charset("utf8");

    }


    // disconnection function
    public function disconnect()
    {

        if ($this->conn != null) {
            $this->conn->close();
        }

    }

    // Insert user details
    public function registerUser($username, $password, $salt, $email, $fullname) {

        // sql command
        $sql = "INSERT INTO users SET username=?, password=?, salt=?, email=?, fullname=?";

        // store query result in $statement
        $statement = $this->conn->prepare($sql);

        // if error
        if (!$statement) {
            throw new Exception($statement->error);
        }

        // bind 5 param of type string to be placed in $sql command
        $statement->bind_param("sssss", $username, $password, $salt, $email, $fullname);

        $returnValue = $statement->execute();

        return $returnValue;

    }


    // Select user information
    public function selectUser($username) {

        $returArray = array();

        // sql command
        $sql = "SELECT * FROM users WHERE username='".$username."'";

        // assign result from $sql to $result
        $result = $this->conn->query($sql);

        // if at least 1 result returned
        if ($result != null && (mysqli_num_rows($result) >= 1 )) {

            // assign results to $row as associative array
            $row = $result->fetch_array(MYSQLI_ASSOC);

            if (!empty($row)) {
                $returArray = $row;
            }

        }

        return $returArray;

    }
    // Save email confirmation message's token
    public function  saveToken($table, $id, $token) {

        $sql = "INSERT INTO $table SET id=?, token=?";
        $statement = $this->conn->prepare($sql);

        if (!$statement) {
            throw new Exception($statement->error);

        }

        // i is int, s is string / bind paramaters to sql
        $statement->bind_param("is", $id, $token);

        $returnValue = $statement->execute();

        return $returnValue;
    }

    // Get ID of user with $emailToken
    function getUserID($table, $token) {

        $returnArray = array();

        $sql = "SELECT id FROM $table WHERE token = $token";
        $result = $this->conn->query($sql);

        if ($result != null && (mysqli_num_rows($result) >= 1)) {

            // content from $result convert to assoc array
            $row = $result->fetch_array(MYSQLI_ASSOC);

            if (!empty($row)) {

                $returnArray = $row;
            }


        }

        return $returnArray;
    }

    // Change status of emailConfirmation

    function emailConfirmationStatus($status, $id) {

        $sql = "UPDATE users SET emailConfirmed=? WHERE id=?";
        $statement = $this->conn->prepare($sql);

        if (!$statement) {

            throw new Exception($statement->error);
        }

        $statement->bind_param("ii", $status, $id);
        $returnValue = $statement->execute();

        return $returnValue;

    }

    // delete token when email confirmed
    function deleteToken($table, $token) {

        $sql = "DELETE FROM $table WHERE token=?";
        $statement = $this->conn->prepare($sql);

        if (!$statement) {

            throw new Exception($statement->error);
        }

        $statement->bind_param("s", $token);
        $returnValue =  $statement->execute();

        return $returnValue;
    }

    // Get full user information
    public function getUser($username) {

        $returnArray = array();

        $sql = "SELECT * FROM users WHERE username='".$username."'";
        $result = $this->conn->query($sql);

        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);

            if (!empty($row)) {
                $returnArray = $row;
            }

        }

        return $returnArray;
    }

    function updateAvaPath($path, $id) {

        $sql = "UPDATE users SET ava=? WHERE id=?";

        $statement = $this->conn->prepare($sql);

        if (!$statement) {
            throw new Exception($statement->error);
        }

        // bind parameters to sql statement
        $statement->bind_param("si", $path, $id);

        // assign execution result to $returnValue
        $returnValue = $statement->execute();

        return $returnValue;

    }

    public function selectUserViaID($id) {

        $returArray = array();

        // sql command
        $sql = "SELECT * FROM users WHERE id='".$id."'";

        // assign result we got from $sql to $result var
        $result = $this->conn->query($sql);

        // if we have at least 1 result returned
        if ($result != null && (mysqli_num_rows($result) >= 1 )) {

            // assign results we got to $row as associative array
            $row = $result->fetch_array(MYSQLI_ASSOC);

            if (!empty($row)) {
                $returArray = $row;
            }

        }

        return $returArray;

    }


}






?>