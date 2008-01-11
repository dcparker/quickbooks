# This file contains several little tidbits of magic that I've made to make certain things easier.
# See Object, Class, and Hash.

class Object
  # This allows one to effectively 'proxy' specific methods to be called on the return value of one of its methods.
  # For example, obj.length could be delegated to do the same thing as obj.full_text.length
  def delegate_methods(hsh)
    raise ArgumentError, "delegate_methods should be called like: delegate_methods [:method1, :method2] => :delegated_to_method" unless hsh.keys.first.is_a?(Array)
    methods = hsh.keys.first
    delegate_to = hsh[methods]
    methods.each do |method|
      self.send(:eval, <<-ddddddd
        def #{method}(*args, &block)
          block_given? ? self.#{delegate_to}.#{method}(*args, &block) : self.#{delegate_to}.#{method}(*args)
        end
      ddddddd
      )
    end
  end

  # Wraps any non-Array into an array
  def to_a
    self.is_a?(Array) ? self : [self]
  end

  # Normally one would say, "if [:a, :b, :c].include?(:a)" -- which is backward thinking, instead you should use this magic:
  # ":a.is_one_of?(:a, :b, :c)", or :a.is_one_of?([:a, :b, :c]).
  def is_one_of?(*ary)
    raise ArgumentError, "exists_in? requires an array to be passed" unless ary.is_a?(Array)
    ary.include?(self)
  end
  # The opposite of is_one_of?
  def is_not_one_of?(*ary)
    !is_one_of?(ary)
  end
end

class Class
  # Returns the class name without the module names that precede it. I'm sure there's a builtin way to do this, but I couldn't find it and this works just as reliably!
  # Examples:
  # - Quickbooks::Qbxml::Request.class_leaf_name # => 'Request'
  # - Quickbooks::Customer.class_leaf_name # => 'Customer'
  def class_leaf_name
    self.name[self.parent.name.length+2,self.name.length-self.parent.name.length-2]
  end
end

class Hash
  # Transform all the keys in the hash to CamelCase format.
  def camelize_keys!
    self.each_key do |k|
      self[k.camelize] = self.delete(k)
    end
  end

  # Returns values in this hash that are uniq or different than in the hash provided.
  # Example:
  #   {:a => :b, :f => :g, :z => :e}.diff(:a => :b, :f => :r, :u => :o) # => {:f => :g, :z => :e}
  def diff(hsh)
    dif = {}
    self.each do |k,v|
      dif[k] = v if !hsh.has_key?(k)
      dif[k] = v if hsh[k] != self[k]
    end
    dif
  end
end
