Feature: Demonstrate the use of inline data in Cucumber steps
  As a electronic online shopping enthusiast
  I want to buy electronics
  In order to show how geeky I am
  AC1: Search, Add to Cart, Checkout, Pay, Receive Confirmation

  Background: Open the site
    Given I have launched the site

  @basic_search_and_checkout
  Scenario: Search and Buy Products with Varying Credit Cards, Shipping, and Products
    And I have searched for
      | search_field |
      | HTC          |
    And I have added HTC One Mini Blue to my cart
    And I begin the checkout process as a guest
    When I enter billing address information
      | first_name | last_name | address1    | country       | state | city     | zip   | email           | phone        |
      | John       | Smith     | 123 Main St | United States | Ohio  | Columbus | 43215 | kma@hotmail.com | 614-555-1212 |
    And I ship to, via shipping method
      | shipping_address_select                                      | shipping_method |
      | John Smith, 123 Main St, Columbus, Ohio 43215, United States | Next Day Air    |
    And I pay via
      | cc_name    | cc_type | cc_number        | cc_month | cc_year | cc_cvc |
      | John Smith | Visa    | 4111111111111111 | 03       | 2023    | 245    |
    And I confirm order totalling $110.00
    Then I will receive a confirmation
