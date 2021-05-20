# frozen_string_literal: true

## PageObject namespace for monkey patching
module PageObject
  extend Forwardable
  def_delegators :root, :visible?, :present?, :exists?

  ##
  # :category: extensions
  # Performs element action and waits for a url to change before moving on
  #
  # This useful for things like login and navigation links.
  #
  # @example
  # page.change_page_using :login
  #
  # Would call the login method on the page, then wait for the URL to change to a new
  # value.
  #
  # @param element [Symbol] - element name as a symbol to act to change page
  # @param opts optional [Hash] - All opts get passed to underlying wait_for_url_change method.
  # @option opts [Symbol] :current_url Pass in the current URL or by default it'll grab the browser URL as current
  def change_page_using(element, opts = {})
    opts[:current_url] ||= @browser.url

    begin
      self.send(element.to_sym)
    rescue StandardError
      wait_for_ajax
      self.send(element.to_sym)
    rescue
      self.send(element.to_sym)
    end

    wait_for_url_change(opts)
  end

  ##
  # :category: extensions
  # Allows you to call a one-off facade for waiting for ajax.
  # By default, a facade is set for the framework, but sometimes you
  # need to call a different facade.
  #
  # @example
  # page.wait_for_ajax_using(:angularjs, 60, 'Ajax took too long')
  #
  # @param facade [Symbol] An options hash.
  # @param timeout [Integer] - how to long to wait for ajax to complete in seconds, default 120 seconds
  # @param message [String] - a message to return if waiting for ajax to complete times out
  def wait_for_ajax_using(facade, timeout = 120, message = nil)
    sleep 1.0 # Give the GW time to start it's ajax requests
    cur_facade = PageObject::JavascriptFrameworkFacade.framework
    PageObject::JavascriptFrameworkFacade.framework = facade
    _wait_for_ajax(timeout, message)
    PageObject::JavascriptFrameworkFacade.framework = cur_facade
  end

  ##
  # :category: extensions
  # Blocks further actions until the browser URL changes.
  #
  # If the supplied options hash does not contain a :current_url key,
  # it will use the browser url.  This could lead to timing issues
  # so you should most likely make a note of the url before initiating the url change.
  # @example
  # page.wait_for_url_change
  #
  # or
  #
  # page.wait_for_url_change({ current_url: 'https://www.google.com' })
  #
  # The change_page_using method does this automatically.
  # @param opts optional [Hash] An options hash.
  # @option opts [String] :current_url The current URL of the page
  # @option opts [String] :target_page Sets the on_page to the page class name passed in
  # @option opts [String] :factory If anything is set on :factory, it sets current_page to page it finds itself on
  def wait_for_url_change(opts)
    url_now = opts.fetch(:current_url, @browser.url)
    Watir::Wait.until { @browser.url != url_now }
    wait_for_ajax
    page = nil
    page = on_page(opts[:target_page].to_s.to_page_class) if opts[:target_page]
    opts[:factory].current_page = page if opts[:factory]
    page
  end

  ##
  # :category: extensions
  # Page will see if ajax calls are pending, and wait up to the specified time (or default)
  #
  # @example
  # page.wait_for_ajax
  # page.wait_for_ajax(120, 'Ajax took too long')
  #
  # @param timeout [Integer] - how to long to wait for ajax to complete in seconds, default 60 seconds
  # @param message [String] - a message to return if waiting for ajax to complete times out
  def wait_for_ajax(timeout = 60, message = nil)
    return wait_for_ajax_using(page_facade_value, timeout, message) if respond_to? :page_facade_value

    _wait_for_ajax(timeout, message)
  end

  ##
  # :category: extensions
  #
  # Wait for ajax calls to complete
  # This differs from the stock wait_for_ajax in that it does not blow up while page navigation is occurring
  # This is called as a part of wait_for_ajax
  # @param timeout [Integer] - how to long to wait for ajax to complete in seconds, default 60 seconds
  # @param message [String] - a message to return if waiting for ajax to complete times out
  def _wait_for_ajax(timeout = 30, message = nil)
    sleep 0.5 # Give the browser time to start it's ajax requests
    _ajax_counter = 0
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      begin
        pending = browser.execute_script(::PageObject::JavascriptFrameworkFacade.pending_requests)
      rescue Selenium::WebDriver::Error::UnknownError
        pending = 0 # JO - I changed this to 0.  Seems to me, if I get an error of any type, the facade script is wrong
      rescue Selenium::WebDriver::Error::NoSuchDriverError
        pending = 0
      end
      # STDOUT.puts "Successfully waited for ajax calls for #{_ajax_counter.to_i / 2} seconds" if pending.zero? && _ajax_counter >= 2
      return if pending.zero?

      _ajax_counter += 1
      sleep 0.5
    end
    raise message || "Timed out (at #{timeout} seconds) waiting for ajax requests to complete"
  end

  def fresh_root
    @browser.element(root.element.instance_variable_get('@selector'))
  end

  ## PageObject::Accessors namespace for monkey patching
  module Accessors
    def select_list(name, identifier = {index: 0}, &block)
      standard_methods(name, identifier, 'select_list_for', &block)
      define_method(name) do
        return platform.select_list_value_for identifier.clone unless block_given?

        send("#{name}_element").value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").fire_event :click
        send("#{name}_element").select(value)
        send("#{name}_element").fire_event :blur
      end
      define_method("#{name}_options") do
        element = send("#{name}_element")
        element&.options ? element.options.collect(&:text) : []
      end
    end

    ##
    # :category: extensions
    #
    # Add a link field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_button(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a div field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_div(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a link field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_link(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a select list that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_select_list(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
      define_method("#{name}=") do |value|
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}=", value)
      end
      define_method("#{name}_options") do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_options")
      end
    end

    ##
    # :category: extensions
    #
    # Add a text field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_text_field(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element").value
      end
      define_method("#{name}=") do |value|
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element").value = value
      end
    end

    ##
    # :category: extensions
    #
    # This mimics the behavior of standard_methods for depricated fields.  This is called by depreciated_text_field
    #
    def depreciated_standard_methods(name, new_name)
      define_method("#{name}_element") do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element")
      end
      define_method("#{name}?") do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}?")
      end
    end

    def masked_text_field(name, identifier = {index: 0}, &block)
      standard_methods(name, identifier, 'text_field_for', &block)
      define_method(name) do
        return platform.text_field_value_for identifier.clone unless block_given?

        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return platform.text_field_value_set(identifier.clone, value) unless block_given?

        send("#{name}_element").value = value
        send("#{name}_element").fire_event 'blur'
      end
    end
  end

  module Accessors
    def page_facade(facade)
      define_method('page_facade_value') do
        facade
      end
    end
  end

  module PageFactory
    attr_accessor :current_page

    def on_current_page(&block)
      yield @current_page if block
      @current_page
    end

    #
    # Create a page object.
    #
    # @param [PageObject, String]  a class that has included the PageObject module or a string containing the name of the class
    # @param Hash values that is pass through to page class a
    # available in the @params instance variable.
    # @param [Boolean]  a boolean indicating if the page should be visited?  default is false.
    # @param [block]  an optional block to be called
    # @return [PageObject] the newly created page object
    #
    def on_page(page_class, params = {:using_params => {}}, visit = false, &block)
      page_class = class_from_string(page_class) if page_class.is_a? String
      return super(page_class, params, visit, &block) unless page_class.ancestors.include? PageObject

      merged = page_class.params.merge(params[:using_params])
      page_class.instance_variable_set("@merged_params", merged) unless merged.empty?
      @current_page = page_class.new(@browser, visit)
      @current_page.wait_till_loaded if @current_page.respond_to?(:wait_till_loaded)
      block.call @current_page if block
      @current_page
    end
  end
end

# TODO: Move to better location
module PageObject
  module Accessors
    #
    # adds a Guidewire specific link to the page object
    #
    # @example
    #   gw_link(:clickable_link, id: "Click here")
    #   will perform JS fire_event :click
    #   instead of standard .click functionality
    #
    # @param  [Symbol] name used for the generated methods
    # @param [Hash] identifier how we find a text field.
    # @param [Block] block - optional: to be invoked when element method is called
    #
    def gw_link(name, identifier = {:index => 0}, &block)
      standard_methods(name, identifier, 'link_for', &block)
      define_method(name) do
        self.send("#{name}_element").fire_event :click
      end
    end

    #
    # adds a method specific file_field to the page object for data populator
    #
    # @param [Symbol] name used for the generated methods
    # @param [Hash] identifier how we find a text field.
    # @param [Block] block - optional: to be invoked when element method is called

    def file_field(name, identifier = {:index => 0}, &block)
      standard_methods(name, identifier, 'file_field_for', &block)
      define_method("#{name}_is_file_field") do

      end
    end

    #
    # GW div Grid interactions
    #
    # Examples
    ###
    # puts self.policy_search_grid_exists_with_data?
    # puts self.policy_search_grid_col_index 'Insured'
    # puts self.policy_search_grid_row_index 'Robert Farley', 'Insured'
    # puts self.policy_search_grid_row_index 'Robert Farley', 2
    #
    # # mixed search_value, col index not supported
    # self.policy_search_grid_click_cell 'Robert Farley', 'Insured'
    # self.policy_search_grid_click_cell 2, 3
    # self.policy_search_grid_click_cell 'San Diego', 4
    # self.policy_search_grid_click_cell 4, 'City'
    #
    # puts self.policy_search_grid_sibling_cell 'Effective', 'Robert Farley', 'Insured'
    # puts self.policy_search_grid_sibling_cell 'Expires', 'Robert Farley', 2
    # puts self.policy_search_grid_sibling_cell 'Address', 0
    #
    # self.policy_search_grid_click_cell_link 'Select', 0
    # self.policy_search_grid_click_cell_link 'Select', 'Allen Robertson', 2
    # self.policy_search_grid_click_cell_link 'Select', '54-586734', 'Policy #'

    def div_grid(name, identifier = {:index => 0}, &block)
      standard_methods(name, identifier, 'div_for', &block)
      define_method(name) do
        return platform.div_text_for identifier.clone unless block_given?

        self.send("#{name}_element").text
      end
      define_method("#{name}_clickout") do |value|
        ele = self.send("#{name}_element")
        ele.click
        ele.fire_event value.to_sym
      end

      # return index of column header with text value
      define_method("#{name}_col_index") do |col_name|
        ele = self.send("#{name}_element")
        ele.div(id: /headercontainer/).divs(class: 'x-column-header').find_index { |col| col.text.match("#{col_name}") }
      end

      # return the row_index of a value in a specific column index (can pass integer in
      #            or find the col index based on column header text )
      define_method("#{name}_row_index") do |search_value, col = ''|
        ele = self.send("#{name}_element")
        col_index = col.is_a?(String) ? self.send("#{name}_col_index", col) : col
        ele.tables(class: /x-grid-item/).find_index { |row| row.td(index: col_index).text.match "#{search_value}" }
      end

      # click on specific grid cell through either indices passed in OR
      #       via column header text passed into col and row search text passed into row
      define_method("#{name}_click_cell") do |row, col|
        ele = self.send("#{name}_element")
        raise ArgumentError.new ("Cannot locate grid data") unless self.send("#{name}_exists_with_data?")

        col_index = col.is_a?(String) ? self.send("#{name}_col_index", col) : col
        row_index = row.is_a?(String) ? self.send("#{name}_row_index", row, col_index) : row

        if row_index.nil? || col_index.nil?
          raise ArgumentError.new ("Could not find correct row and/or column for target cell. Looking for index related to row #{row} and column related to #{col}")
        end

        ele.table(index: row_index).td(index: col_index).click
      end

      # click links inside a cell.  will click on link text based on row/col indices OR
      #       col_header text and row search value
      define_method("#{name}_click_cell_link") do |link_text, row, col = ''|
        ele = self.send("#{name}_element")
        raise ArgumentError.new ("Cannot locate grid data") unless self.send("#{name}_exists_with_data?")

        col_index = col.is_a?(String) ? self.send("#{name}_col_index", col) : col
        row_index = row.is_a?(String) ? self.send("#{name}_row_index", row, col_index) : row

        if row_index.nil? || col_index.nil?
          raise ArgumentError.new ("Could not find correct row and/or column for target cell. Looking for index related to row #{search_row} and column related to #{search_col}")
        end

        ele.table(index: row_index).link(text: link_text).click
      end

      # click on specific grid cell through either indices passed in OR
      #       via column header text passed into col and row search text passed into row
      define_method("#{name}_sibling_cell") do |target_column, search_row, search_col = ''|
        ele = self.send("#{name}_element")
        raise ArgumentError.new ("Cannot locate grid data") unless self.send("#{name}_exists_with_data?")

        # get sibling index
        target_column_index = self.send("#{name}_col_index", target_column)
        raise ArgumentError.new ("Could not find target column name. Looking for #{target_column}") if target_column_index.nil?

        col_index = search_col.is_a?(String) ? self.send("#{name}_col_index", search_col) : search_col
        row_index = search_row.is_a?(String) ? self.send("#{name}_row_index", search_row, col_index) : search_row

        if row_index.nil? || col_index.nil?
          raise ArgumentError.new ("Could not find correct row and/or column for target cell. Looking for index related to row #{search_row} and column related to #{search_col}")
        end

        ele.table(index: row_index).td(index: target_column_index).text
      end

      define_method("#{name}_exists_with_data?") do
        ele = self.send("#{name}_element")
        return false unless ele.exists?

        ele.tables(class: /x-grid-item/).count > 0 ? true : false
      end
    end
  end
end
module PageObject
  module Javascript
    module ExtJS
      #
      # returns if Ajax calls are still processing
      # @return [Boolean] returns true if Ext.Ajax.isLoading() is true, otherwise false
      def self.pending_requests
        'return Ext.Ajax.isLoading() ? 1 : 0'
      end
    end
  end
end
