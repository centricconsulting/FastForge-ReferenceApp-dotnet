# Managing Test Data

Centric is offering 3 ways to manage test data within the framework.  Each has it's pros and cons.  We'll describe each approach, a demonstration of that approach, and the benefits/drawbacks of using that approach.

## Inline Format - Single Scenario

The inline format stores the test data as a part of the cucumber test itself.  

```gherkin
Scenario: Search and Buy Products with Varying Credit Cards, Shipping, and Products
    And I have searched for
      | search_field |
      | HTC          |
    And I have added HTC One Mini Blue to my cart
    And I begin the checkout process as a guest
    When I enter billing address information
      | first_name | last_name | address1    | country       | state | city     | zip   | email           | phone        |
      | John       | Smith     | 123 Main St | United States | Ohio  | Columbus | 43215 | kma@hotmail.com | 614-555-1212 |
```



As you can see, the test data is visible with the step itself.  There are 2 examples of this approach.

###### Example 1

- ```gherkin
  And I have added HTC One Mini Blue to my cart
  ```

- This step passes 'HTC One Mini Blue' as a variable to the step.  The underlying step then knows what to do with it.
- We use this style when we only have to pass in value - the underlying step must know what field to put this value in.

###### Example 2

- ```gherkin
   When I enter billing address information
        | first_name | last_name | address1      | ...|
        | John            | Smith         | 123 Main St | ...|
  ```

- This step passes the field name(s) and value(s) to the underlying framework as a hash.
- We use this style when we have to populate an entire page of data.

| Benefit                                                | Drawback                                                     |
| ------------------------------------------------------ | ------------------------------------------------------------ |
| Data is easily visible, and readable to any/all users. | Approach requires user to know what field names the suite uses to ensure data is passed to the correct field. |
|                                                        |                                                              |

## Inline Format - Outline Scenario

Identical to above, this inline format stores the test data as a part of the cucumber test itself, but as an outline with examples as rows.  

```gherkin
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

```

| Benefit                                                      | Drawback                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Data is easily visible, and readable to any/all users.       | Approach requires user to know what field names the suite uses to ensure data is passed to the correct field. |
| User is able to rapid add data combination scenarios, simply by changing data table, without altering the underlying test steps. | Scenario is limited to exact same approach for all 3 examples.  User cannot add different steps for different scenarios. |

## YML Format

This format removes all test data from within the test steps themselves, and stores in an external file.  File used is controlled via @cucumber tag.

```gherkin
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
```

Data Control via Filename - YML file is loaded based on the @fixture tag on the test.  In this case, guest01.yml file will be loaded.  All fixture files must be prefixed in the tag with @fixture_.

- All fixture files are located in the [./fixtures](./fixtures) folder by default

Fixture files are complex and are discussed in separate readme: [./docs/Using YML Fixture Files.md](./docs/Using YML Fixture Files.md). 

| Benefit                                                      | Drawback                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Data is stored in a single location.                         | Data inherited is not easily visible to a user.  Requires tracing through multiple files |
| User is able to rapidly add/modify data simply by changing data values, without altering the underlying test steps. | Data is not visible inside test steps or results (without additional logging). |
| Data uses inheritance allowing for better data control and reusability | Highest form of abstraction makes some troubleshooting more difficult |
| Allows for hierarchical data - e.g., a claim policy could have one or more vehicles in the yml file.  Test steps can easily iterate over list of vehicles and add as many as exist.  Prevents users from abusing repetitive steps. |                                                              |

## Embedded Test Class Data

This approach embeds test data within a page object class.  This only applies to default data for a given page.

```ruby
class BillingSection < BasePage
  text_field(:first_name, id: 'BillingNewAddress_FirstName')
  text_field(:last_name, id: 'BillingNewAddress_LastName')
  text_field(:email, id: 'BillingNewAddress_Email')
  select_list(:country, id: 'BillingNewAddress_CountryId')
  select_list(:state, id: 'BillingNewAddress_StateProvinceId')
  text_field(:city, id: 'BillingNewAddress_City')
  text_field(:address1, id: 'BillingNewAddress_Address1')
  text_field(:zip, id: 'BillingNewAddress_ZipPostalCode')
  text_field(:phone, id: 'BillingNewAddress_PhoneNumber')
  button(:continue, value: 'Continue', visible: true)

  def default_data
    { first_name: 'John',
      last_name: 'Smith',
      country: 'United States',
      state: 'Ohio',
      address1: '123 Main St',
      city: 'Columbus',
      zip: '12345',
      phone: '123-456-7893',
      email: 'kma@hotmail.com' }
  end
end
```

In this approach, data is stored as a hash in the `default_data` method.  If data is not passed in the test step, and not provided via a yml file, the `default_data` method will provide a hash of default data to use.  

| Benefit                                                      | Drawback                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Useful for when user may not specify or care about data for a given page.  User can always override data by passing in their own, or by using the `additional = {}` in the page and page_section populate method. | Data is not easily visible to user, cannot be easily changed.  Requires code change to implement. |
|                                                              | Data only applies to default data for a page, not for other data for a page |


# Populating pages
The base page class has a populate method that will automagically use the fixture data for the page being populated if it exists in the fixture file.

The populate method has a different signature than the standard populate method in PageObject.  It looks like this:

``` ruby
def populate(data = {}, additional_data: {}, cache_data: false)
```

If the _data_ parameter is supplied that data will be used for the page instead of the fixture data. The _additional_ parameter allows you to add/overwrite fixture data to be used.  For example:

```ruby
data = { hardcoded_key: value}
# this will only populate the page with the passed in data
page.populate(data)

# The method traverses a hierarchy
# Where we look for default_data stored in the page class itself first, 
# If none is found, we look for data stored in an associated yml file with the page class as the top level key
# Finally, we merge in additional data if there is additional data available
page.populate({}, additional_data: { some_page: { first_name: 'fred' } })
```
### Dynamic DataMagic Data
Each time you call populate or the data\_for method, DataMagic translators are run again.  This can be a major problem if your fixture includes translators.  

* Pages should cache data when populating.  This method will update a cache with the last generated values.
* Stepdefs that need to refer back to the generated data should use the DataForCache like so:

```ruby
# Populating
populate_page_with 'my_page', cache_data: true

# Validating later
data_used = DataForCache['my_page']
```

### Calling data_for manually
Since the Centric applications use so many sections, and dialogs using a straight up populate will not usually get you where you need to be.  In those cases you'll want to exercise the UI to get the elements you want to populate visible, the call populate_with yourself.

```ruby
page.show_contacts
page.populate({ key: value })
page.populate_with data_for :some_page_contact_section
```

### Important
Due to the way data\_magic evaluates macros, calling data_for with the same key at different times can give you different results.  This can make it hard verify that the data was entered correctly. 

Review the README for [Using YML Fixture Files.md](Using YML Fixture Files.md) for more details on using caching of data results.