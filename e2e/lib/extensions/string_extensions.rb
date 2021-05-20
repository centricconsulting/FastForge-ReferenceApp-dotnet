# frozen_string_literal: true

class String
  # Covert a string to a page class name
  # @example 'foo' becomes FooPage
  # @example 'login_page' becomes LoginPage
  #
  # :category: extensions
  #
  # @return [Object] returns the Page as an object based on name
  # @author Donavan Stanley
  def to_page_class_name
    res = camelcase(:upper).delete(' ')
    res = "#{res}Page" unless res =~ /Page$/
    res
  end

  # Convert a string containing a page class name to its constant
  #
  # @return [String] returns page class name a constant
  # :category: extensions
  def to_page_class
    Object.const_get to_page_class_name
  end

  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def orange;         "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def pink;           "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  def default;        self                 end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_orange;      "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_pink;        "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end
  def bg_default;     self                 end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
end
