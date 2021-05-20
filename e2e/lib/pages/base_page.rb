# frozen_string_literal: true

require 'data_magic'
require 'facets/string/snakecase'

# Base class for all pages in the framework
class BasePage
  include PageObject
  include DataMagic
  include PageFactory
  include PagePopulate

  page_url 'http://centricconsulting.azurewebsites.net/'

  # Base classes should override this to provide default data
  # This is to set default data for each page. Store default data in a
  # Hash { field_name: value }
  def default_data
    {}
  end
end
