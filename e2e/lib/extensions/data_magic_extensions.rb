## DataMagic namespace for monkey patching
require 'singleton'
class DataForCache
  include Singleton
  attr_accessor :cache

  def self.[](key)
    DataForCache.instance.cache_get(key.to_s)
  end

  def initialize
    @cache = {}
  end

  def cache_get(key)
    @cache[key]
  end

  def cache_set(key, data)
    @cache[key] = data
    data
  end
end

module DataMagic
  ##
  # :category: extensions
  #
  # Works like the existing data_for but instead of blowing up if the key is missing returns the data found in +default+
  def data_for_or_default(key, default = {}, additional = {}, cache = true)
    if key.is_a?(String) && key.match(%r{/})
      filename, record = key.split('/')
      DataMagic.load("#{filename}.yml")
    else
      record = key.to_s
      DataMagic.load(the_file) unless DataMagic.yml
    end

    begin
      data = DataMagic.yml[record].nil? ? {} : DataMagic.yml[record]
    rescue NoMethodError
      # this means page/section doesn't exist in yml file, so use default data
      data = {}
    end

    data = default.dup if data.empty?
    additional.key?(record) ? prep_data(data.merge(additional[record]).clone) : prep_data(data)

    # cache data
    return data unless cache

    DataForCache.instance.cache_set(record, data)
  end


  def data_for?(key)
    if key.is_a?(String) && key.match(%r{/})
      filename, record = key.split('/')
      DataMagic.load("#{filename}.yml")
    else
      record = key.to_s
      DataMagic.load(the_file) unless DataMagic.yml
    end
    DataMagic.yml.key? record
  end

  def embedded_data_for(outer_key, inner_key)
    begin
      data_for(data_for(outer_key)[inner_key])
    rescue Exception => e
      if e.message == 'Undefined key'
        raise ArgumentError.new("Could not find loss location data. Looking at #{ data_for('loss_location') }")
      else
        raise e
      end
    end
  end
end

## YmlReader namespace for monkey patching
module YmlReader
  ##
  # :category: extensions
  #
  # Loads the requested file.  It will look for the file in the
  # directory specified by a call to the yml_directory= method.
  # uses load_erb
  def load(filename)
    @yml = YAML.load_erb "#{yml_directory}/#{filename}"
  end
end
