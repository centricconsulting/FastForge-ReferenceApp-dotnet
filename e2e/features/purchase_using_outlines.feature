Feature: Demonstrate Default Page Data, Cucumber Outlines
  As a electronic online shopping enthusiast
  I want to buy electronics
  In order to show how geeky I am
  AC1: Search, Add to Cart, Checkout, Pay, Receive Confirmation

  Background: Open the site
    Given I have launched the site

  @demo_use_page_default_data @demo_outlines
  Scenario Outline: Search and Buy Products with Varying Credit Cards, Shipping, and Products
    And I have searched for specific <product>
    And I have added <product_name> to my cart
    When I begin the checkout process as a guest
    And I enter default billing address information
    And I select <shipping> shipping
    And I pay via a <cc_type> using <account> with <cvv>
    And I confirm order totalling <total>
    Then I will receive a confirmation

    Examples:
      | product | product_name                    | shipping     | cc_type  | account          | cvv  | total   |
      | HTC     | HTC One Mini Blue               | Next Day Air | Amex     | 378282246310005  | 1234 | $110.00 |
      | Adobe   | Adobe Photoshop CS4             | 2nd Day Air  | Visa     | 4111111111111111 | 123  | $75.00  |
      | Beats   | Beats Pill 2.0 Wireless Speaker | Ground       | Discover | 5105105105105100 | 123  | $79.99  |
