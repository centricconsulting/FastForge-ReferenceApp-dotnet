### Fixtures
* Fixtures within the Centric framework use the [DataMagic gem](https://github.com/cheezy/data_magic) to do the heavy lifting. 
* Fixtures are located in the folder [./fixtures](./fixtures) and should be given a meaningful name.  Either the name of the scenario/feature or the card number from the automation scrum board if available.
* Fixtures are automatically loaded by the framework if a fixture tag is provided (See below).  Example: `@fixture_as_32` would load the YAML file `as_32.yml` in the fixtures folder.
* DataMagic and YAML have been extended to provide additional functionality.  YAML files, can include other YAML files, and DataMagic has been modified to use this.
    * This allows you to reuse common data, without duplicating it.  Given a YAML file in [./fixtures](./fixtures) like so:

```yaml
<%= YAML.include('customers/random_user.yml') %>
<%= YAML.include('payment_info/credit_cards.yml') %>
billing_section:
  <<: *user_01
payment_info_section:
  cc_name: ~full_name
  <<: *amex_01
shipping_method_section:
  shipping: Next Day Air
```

When loaded this will produce the following YAML:

```yaml
billing_section:
  first_name: ~first_name
  last_name: ~last_name
  address1: 123 Main St
  city: Columbus
  country: United States
  state: Ohio
  zip: 43215
  email: ~email_address
  phone: ~cell_phone
payment_info_section:
  cc_name: ~full_name
  card_type: Amex
  cc_number: 378282246310005
  cc_month: '03'
  cc_year: ~today(format = '%Y')
  cc_cvc: 123
shipping_method_section:
  shipping: Next Day Air
```

* Paths for YAML files included from within other YAML files are relative.  

* To use a fixture in a scenario use the @fixture_ tag.  For example "@fixture\_sample\_fixture" will load ./fixtures/sample\_fixture.yml to use.


Data for pages should match the page name in snake case.  For example the page class `SearchPage` becomes `search_page`.
Data for page sections should match the page section name in snake case.  For example the page section class `BillingSection` becomes `billing_section`.  Class `PaymentInfoSection` becomes `payment_info_section`.
### Randomizing Data
This approach has a built-in randomization method using Faker gem via DataMagic gem.  Fields with ~ prefix are randomly generated at evaluation time.
* ~cell_phone will produce a cell phone number
* ~first_name will produce a random first name.  It's important to note that ~full_name produces a  first and last name, but not the same first name as ~first.  Again, values are generated randomly at evaluation.

### Populating pages
* Most pages support population from fixtures, provided that the fixture file has a key that corresponds to the page class name in snake case.   For example MyCoolPage would be my\_cool_page.

* The base page class has a populate method that will automagically use the fixture data for the page being populated if it exists in the fixture file.

* The populate method has a different signature than the standard populate method in PageObject.  It looks like this:

``` ruby
def populate(data = {}, additional = {}, cache_data = false)
```

If the _data_ parameter is supplied that data will be used for the page instead of the fixture data. The _additional_ parameter allows you to add/overwrite fixture data to be used.  For example:

```ruby
page.populate({}, { some_page: { first_name: 'fred' } }, true)
```

Will populate the page using the data from the fixture with the exception of the first name, which will be replaced by `'fred'`.
The additional hash can contain replacement and/or new field/value pairs.

## DataMagic translators
The Centric framework defines some additional translators for DataMagic:

* time_name - Creates a name with a timestamp attached to ensure uniqueness. For example `~time_name('foo')` would generate a name that looks like timestamp down to the ms `foo20201105111500456`
* company_type - Generates a random company type that's valid for creating a company.
* unique_email - generates a unique email `~unique_email('starts_name','mydomain.com')` would generate `starts_with+20201105111500456@mydomain.com`

### Working with dynamic names
Each time you call data\_for, the translators are run again.  This can be a major problem if your fixture includes translators.  

* Pages should cache data when populuating.  This method will update a cache with the last generated values.
* Stepdefs that need to refer back to the generated data should use the DataForCache like so:

```ruby
# Populating
populate_page_with 'my_page', {}, true

# Validating later
data_used = DataForCache['my_page']
```