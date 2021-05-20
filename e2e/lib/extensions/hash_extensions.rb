# frozen_string_literal: true

# Extensions to the Hash class
class Hash
  # Returns a hash that includes everything but the given keys.
  #   hash = { a: true, b: false, c: nil}
  #   hash.except(:c) # => { a: true, b: false}
  #   hash # => { a: true, b: false, c: nil}
  #
  # This is useful for limiting a set of parameters to everything but a few known toggles:
  #   @person.update(params[:person].except(:admin))
  def except(*keys)
    dup.except!(*keys)
  end

  # Replaces the hash without the given keys.
  #   hash = { a: true, b: false, c: nil}
  #   hash.except!(:c) # => { a: true, b: false}
  #   hash # => { a: true, b: false }
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end

  # Add a prefix to all keys in a hash
  def prepend_key!(prefix)
    return unless self.is_a?(Hash)
    Hash[self.map { |k, v| ["#{prefix}_#{k}", v] }]
  end

  def cleaned
    self.delete_if { |_k, v| v.nil? || v.empty? }
    pass1 = self.each_with_object({}) { |(k, v), h| h[k] = v.to_s.casecmp('true').zero? ? true : v; }
    pass2 = pass1.each_with_object({}) { |(k, v), h| h[k] = v.to_s.casecmp('false').zero? ? false : v; }
    pass2
  end
end
