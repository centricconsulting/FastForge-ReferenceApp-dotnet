Feature: Demonstrate the use of fixtures in the test suite
  As a electronic online shopping enthusiast
  I want to buy electronics
  In order to show how geeky I am
  AC1: Search, Add to Cart, Checkout, Pay, Receive Confirmation

  Background: Open the site
    Given I have launched the site

  @fixture_guest01 @demo_yml
  Scenario: Search and Buy Products with Varying Credit Cards, Shipping, and Products
    And I have searched for specific HTC
    And I have added HTC One Mini Blue to my cart
    When I begin the checkout process as a guest
    And I enter fixture billing address information
    And I select the shipping method
    And I enter payment information
    And I confirm order totalling $110.00
    Then I will receive a confirmation