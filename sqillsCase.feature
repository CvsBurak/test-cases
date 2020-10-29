Feature: Sqills cucumber test case

  Scenario: Client uses RESTAPI on localhost:8080/customer
    Given Client checks the customers
    When Client add new customer with POST
    Then New customer created succesfully
    When Clinet deletes customer with DELETE
    Then Customer has deleted succesfully
