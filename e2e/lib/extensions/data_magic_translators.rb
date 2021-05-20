# frozen_string_literal: true

# This module houses all data magic translators that are custom translators
# See Using YML Fixture Files.md for details on how to use
module Centric
  # Generate a string with a ms timestamp
  # Declared in fixutre yml file as ~time_name('foo')
  # Returns 'foo20201105111500456'
  # @param prefix [String] The starting name portion of the string.  Current date/time to MS is appended
  # @return [String] Current date/time to MS is appended
  def time_name(prefix = 'Automation')
    "#{prefix}#{Time.now.strftime '%Y%m%d%H%M%S%L'}"
  end

  COMPANY_TYPES = ['Unknown', 'Association', 'Building Maintenance', 'Business, Professional', 'Business, Retail',
                   'Church', 'Educational Facility', 'Arts/Entertainment/Leisure Facility', 'Flooring/Furniture Provider',
                   'General Contractor/Builder', 'Government Facility/Municipality', 'Home/Building Inspection Service',
                   'Home/Business Repair Professional', 'Insurance Professional', 'Land Subdivider/Developer',
                   'Lodging/Hospitality Management', 'Medical Facility', 'Plumber/HVAC',
                   'Property Management', 'Real Estate Agent/Manager', 'Restaurant/Dining', 'Roofer',
                   'Title Abstract Office', 'Title Insurance', 'Transportation Provider',
                   'Subcontractor'].freeze
  # return a random company from the list
  # @return [String] The starting name portion of the string.  Current date/time to MS is appended

  def company_type
    COMPANY_TYPES[rand(COMPANY_TYPES.count - 1)]
  end

  # Generate a unique email address that's compatible with gmail
  # it works by appending '+' and a timestamp to the username
  # portion of the email address.  Gmail will ignore everything after
  # the '+' and deliver the email.
  #
  # This allows us to have one-time email addresses that all map back
  # to the same common email account.
  # Declare in fixutre yml as `~unique_email('starts_name','mydomain.com')`
  # Return generated string `starts_with+20201105111500456@mydomain.com`
  # @param name [String] The name portion of the email address
  # @param domain [String]
  # @return [String] unique email
  def unique_email(name, domain)
    "#{name}+#{Time.now.strftime '%Y%m%d%H%M'}@#{domain}"
  end

end
DataMagic.add_translator Centric # this line must go in the same file as the module

# frozen_string_literal: true

# Extensions to the integer class
class Integer
  # @return [string] A date string X number of months from now
  def months_from_today(format = '%D')
    the_day = Date.today >> self
    the_day.strftime(format)
  end

  # @return [string] A date string X number of months from ago
  def months_ago(format = '%D')
    the_day = Date.today << self
    the_day.strftime(format)
  end
end
