# frozen_string_literal: true

# Custom module with methods to populate a page.  Overrides some methods in PagePopulator in PageObject gem
module PagePopulate
  #
  # This method populates a page's controls based on a hash passed in (leveraging DataMagic and/or Fixtures)
  # There are several functions within this method that need explained:
  # First, you can pass in a hash.  This takes the form of { field_name: value, field_name: value }
  # For example: { 'official_report_type'=>'Police','official_name'=>'Capt. Adam' } will set the official_report_type to 'Police' and will set the official_name field to 'Capt. Adam'
  # If using fixtures or routes, there may be default data.  If no data is passed in the first parameter
  # It will try to find the data, using the data_for method in Page-Object, and it will look for data related to
  # the current page, or default data.
  # The additional hash can be additional data to populate, but data must be empty first.
  # @example
  # page.populate # populates values based on either default data or fixture data based on the current page's class name
  #
  # page.populate({ 'official_report_type'=>'Police','official_name'=>'Capt. Adam' }) # will populate the page based on the input hash ONLY!
  #
  # page.populate({ loss_category: 'Collision', loss_cause: 'Collision with motor vehicle' },{ 'official_report_type'=>'Police','official_name'=>'Capt. Adam' }) # will use default or fixture data for the page and ADD the additional hash data
  #
  # @param data optional [Hash] this is the main data to use on the page, it is stored in the page class file in a { field_name: value } format
  # @param additional_data optional [Hash] This is additional data to merge in, or data to overwrite from other methods { field_name: value } format
  # @param cache_data optional [Boolean] this tells us whether to cache the data.  In DataMagic, some values are random or time generated, this saves that information for later use
  def populate(data = {}, additional_data = {}, cache_data = true)
    # this logic is a bit confusing.  The hierarchy in finding data is
    # data passed in via data = {}, that is first precedent. NO ADDITIONAL DATA IS MERGED IN when passing in data directly.
    # Next is default_data stored in teh page class itself
    # Next is data stored in an associated yml file with the page class as the top level key
    # Finally, we merge in additional data if there is additional data available
    #
    # So, we check if passed in data hash is empty, if so, we go through the heirarchy above
    # otherwise, we populate with data itself.
    data.empty? ? populate_page_with(data_for_or_default(self.class.to_s.snakecase, default_data, additional_data, cache_data)) : populate_page_with(data)
  end

  #
  # This method will populate all matched page or page_section TextFields,
  # TextAreas, SelectLists, FileFields, Checkboxes, and Radio Buttons from the
  # Hash passed as an argument.  The way it find an element is by
  # matching the Hash key to the name you provided when declaring
  # the element on your page.
  #
  # Checkbox and Radio Button values must be true or false.
  #
  # @example
  #   class ExamplePage
  #     include PageObject
  #
  #     text_field(:username, id: 'username_id')
  #     checkbox(:active, id: 'active_id')
  #   end
  #
  #   ...
  #
  #   @browser = Watir::Browser.new :firefox
  #   example_page = ExamplePage.new(@browser)
  #   example_page.populate_page_with { username:  'a name', active: true }
  #
  # @param data [Hash] the data to use to populate this page.  The key
  # can be either a string or a symbol.  The value must be a string
  # for TextField, TextArea, SelectList, and FileField and must be true or
  # false for a Checkbox or RadioButton.
  #
  def populate_page_with(data = {})
    return if data.nil? || data.empty?

    data.to_h.each do |key, value|
      populate_section(key, value) if value.respond_to?(:to_h)
      populate_value(self, key, value)
    end
  end

  # This method is better called by an iterating method, such as populate
  #
  # This the method that populates a matched page or page_section field
  #
  # @example
  #   class ExamplePage
  #     include PageObject
  #
  #     text_field(:username, id: 'username_id')
  #     checkbox(:active, id: 'active_id')
  #   end
  #
  #   ...
  #
  #   @browser = Watir::Browser.new :firefox
  #   example_page = ExamplePage.new(@browser)
  #   example_page.populate_value(self, :username, true)
  #
  # @param receiver [PagePopulate] this is the page class/object of the page currently on
  # @param key [String] this is the semantically named field
  # @param value [String] this is value for that field
  # For TextField, TextArea, SelectList, and FileField, etc... - must be string
  # For Checkbox or RadioButton - must be true/false.
  #
  def populate_value(receiver, key, value)
    populate_checkbox(receiver, key, value) if is_checkbox?(receiver, key) && is_enabled?(receiver, key)
    populate_radiobuttongroup(receiver, key, value) if is_radiobuttongroup?(receiver, key)
    populate_radiobutton(receiver, key, value) if is_radiobutton?(receiver, key) && is_enabled?(receiver, key)
    populate_select_list(receiver, key, value) if is_select_list?(receiver, key) && is_enabled?(receiver, key)
    populate_file_field(receiver, key, value) if file_field?(receiver, key) # file fields are usually hidden

    # lots of things respond to #{key}=, so we need to exclude them so we don't trigger twice
    if is_text?(receiver, key) && is_enabled?(receiver, key) && !file_field?(receiver, key) && !sf_dropdown?(receiver, key)
      populate_text(receiver, key, value)
    end

    # Customizations for Salesforce
    populate_sfdropdown(receiver, key, value) if sf_dropdown?(receiver, key) && is_enabled?(receiver, key)
  end

  # Most of the following methods are designed to control when a field matches or not.
  # the is_ functions, are there to verify fields are of a certain type.  Primiarily used to
  # identify/segregate one field type from another. For example, FileFields respond to TextField methods, but
  # they must be set appropriately.  Also, Guidewire's use of underlying text fields for different types of
  # controls creates it's own issues.  gw_dropdown, gw_autofill all respond to TextField methods.  So we have to
  # add custom methods in those controls, and check what type of control it is before attempting to set.
  # As a result, we have to add custom populate methods too.
  private

  # this method populates a page section.  It is similar to a page, but it must
  # respond to a section, then it'll set the value
  def populate_section(section, data)
    # return unless self.respond_to? section
    return unless respond_to? section

    data.to_h.each do |key, value|
      # populate_value(self.send(section), key, value)
      populate_value(send(section), key, value)
    end
  end

  def is_text?(receiver, key)
    receiver.respond_to?("#{key}=".to_sym)
  end

  def populate_text(receiver, key, value)
    receiver.send "#{key}=", value
    wait_for_ajax
  end

  # Detection for normal Watir fields
  def select?(receiver, key)
    receiver.respond_to?("#{key}_options")
  end

  # Watir FileField detection and populate
  def file_field?(receiver, key)
    receiver.respond_to?("#{key}_is_file_field")
  end

  def populate_file_field(receiver, key, value)
    receiver.send("#{key}_element").value = value
    receiver.wait_for_ajax
  end

  # # Textarea populate
  # def populate_textarea(receiver, key, value)
  #   receiver.send("#{key}=", value)
  # end

  # Salesforce Dropdown detection and populate
  def sf_dropdown?(receiver, key)
    receiver.respond_to?("#{key}_is_sf_dropdown")
  end

  def populate_sfdropdown(receiver, key, value)
    receiver.send("#{key}=", value)
  end
end
