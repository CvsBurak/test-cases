package sqillsCase;

import java.util.List;
import java.util.Map;

import org.junit.Assert;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

public class sqillsDefs {

    private static final String BASE_URL = "http://localhost:8080";

    @Given("^Client checks the customers")
    public void getNames(){
        RestAssured.baseURI = BASE_URL;
        RequestSpecification request = RestAssured.given();
        request.header("Content-Type", "application/json");
        response = request.get("/customers");
        jsonString = response.asString();
        List<Map<String, String>> names = JsonPath.from(jsonString).get("first_name");
        name = names.get(0).get("first_name");
    }

    @When("^Client add new customer with POST")
    public void addNewCustomer(){
        RestAssured.baseURI = BASE_URL;
        RequestSpecification request = RestAssured.given();
        request.header("Content-Type", "application/json");

        response = request.body("{ \"first_name\": \"" + "burak" + "\", " +
                "\"last_name\": \"" + "cavusoglu" + "\"}")
                .post("/customers");

    }
    @Then("^Then New customer created succesfully")
    public void clientAdded() {
        Assert.assertEquals(201, response.getStatusCode());
    }

    @When("When Clinet deletes customer with DELETE")
    public void removeCustomer() {
        RestAssured.baseURI = BASE_URL;
        RequestSpecification request = RestAssured.given();

        request.header("Content-Type", "application/json");

        response = request.body("{ \"first_name\": \"" + "burak" + "\", " +
                "\"last_name\": \"" + "cavusoglu" + "\"}")
                .delete("/customers");
    }

    @Then("Then Customer has deleted succesfully")
    public void customerRemoved() {
        Assert.assertEquals(204, response.getStatusCode());

    }
}
