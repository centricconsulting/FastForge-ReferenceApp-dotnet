# frozen_string_literal: true

# The 'page' type will match on .* page and create an appropriate constant
# So "I should be on the login page" would give you a LoginPage
ParameterType(
    name:        'page',
    regexp:      /(.*) page/,
    transformer: ->(class_name) { class_name.to_page_class }
)

# The should type will map 'should' to true and 'should not' to false.
ParameterType(
    name:        'should',
    regexp:      /(should not|should)/,
    transformer: ->(cond) { !cond.match?(/not/) }
)
