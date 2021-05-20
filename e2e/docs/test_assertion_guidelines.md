# Guidelines for validation in the Centric framework

## Error Messages

It's important that when a test fails the error message it provides is clear and meaningful.   "Expected true got false" is terrible, even "Expected John Smith got Fred Durst" is terrible.

Every "expect" should include a custom error message. "Expected the contact name to be John Smith, got: Fred Durst" is much clearer.


## Validating multiple fields

When validating multiple fields, instead of having a ton of expect lines it's better build an array of field names and loop over them using send to get the values.  This pattern looks something like this:

```ruby
df = DataForCache['add_business_with_contact_page']
%w[address1 address2 address3 city state zip_code teritory ].each do |field|
  expected = df[field]
  actual = page.send("nonedit_#{field}")
  expect(actual).to eq(expected), "Expected #{field} to be '#{expected}' but it is '#{actual}'"
end

```

In the above example, we're grabbing the cached data from our yaml so we don't get bitten by DataMagic regenerating dynamic data.  Next we're looping over each field we care about. We can grab the expected straight from the hash. The page refers to these fields by different names, so instead of just calling "send(field)" we build the correct name then send it.  This allows us to do in 5 lines what could take dozens normally.


## Errors for multiple fields
When validating multiple fields like in the above example, we still have another problem.  The test will fail when the first expectation fails.  What we really want is to validate ALL of the fields then report all that failed.

The Centric framework includes an extension to Spec for just that purpose.  By wrapping our code in an "capture_assertions" block we can raise all the exceptions we want and have them reported once the block exits.  Using it is simple, using the above example it would look like this:


```ruby
df = DataForCache['add_business_with_contact_page']
RSpec.capture_assertions do 
	%w[address1 address2 address3 city state zip_code teritory ].each do |field|
	  expected = df[field]
	  actual = page.send("nonedit_#{field}")
	  expect(actual).to eq(expected), "Expected #{field} to be '#{expected}' but it is '#{actual}'"
	end
end
```

Now if the address is completely missing.  Instead of` "Expected address1 to be 'foo' but it is 'bar'"` We get something like: 

```
One or more assertions failed:
Expected address1 to be 'foo' but it is 'bar'
Expected address2 to be 'fizz' but it is 'buzz'