require 'formatted_string'
require 'builder'
require 'hash_magic'

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

  # Normally one would say, "if [:a, :b, :c].include?(:a)" -- which is backward thinking, instead you should use this magic:
  # ":a.is_one_of?(:a, :b, :c)", or :a.is_one_of?([:a, :b, :c]).
  def is_one_of?(*ary)
    raise ArgumentError, "exists_in? requires an array to be passed" unless ary.is_a?(Array)
    ary.flatten.include?(self)
  end
end

class Class
  def lone_name
    name.gsub(/.*::/, '')
  end
end

class String
  def constantize
    Object.module_eval("::#{self}", __FILE__, __LINE__)
  end

  def underscore
    gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
  end

  def camelize
    gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
end

class Array
  def camelize_values(specials={})
    self.dup.camelize_values!(specials)
  end
  def camelize_values!(specials={})
    self.each_with_index do |v,i|
      self[i] = specials.has_key?(v) ? specials[v] : (v.is_a?(Symbol) ? v.to_s.camelize.to_sym : v.camelize)
    end
    self
  end

  def stringify_values
    self.dup.stringify_values!
  end
  def stringify_values!
    self.each_with_index { |v,i| self[i] = v.to_s }
    self
  end

  def only(*values)
    self.dup.only!(*values)
  end
  def only!(*values)
    values.flatten!
    i = 0
    while i <= length-1 do
      self[i].is_one_of?(values) ? i += 1 : self.slice!(i)
    end
    self
  end

  def order(*ordered)
    self.dup.order!(*ordered)
  end
  def order!(*ordered)
    self.replace(ordered.flatten!.only!(self))
  end
end

class Hash
  # Transform all the keys in the hash to CamelCase format.
  def camelize_keys(specials={})
    self.dup.camelize_keys!(specials)
  end
  def camelize_keys!(specials={})
    self.each_key do |k|
      self[specials.has_key?(k) ? specials[k] : k.camelize] = self.delete(k)
    end
    self
  end

  def stringify_keys(specials={})
    self.dup.stringify_keys!(specials)
  end
  def stringify_keys!(specials={})
    self.each_key do |k|
      self[specials.has_key?(k) ? specials[k] : k.to_s] = self.delete(k)
    end
    self
  end

  def only(*keys)
    self.dup.only!(*keys)
  end
  def only!(*keys)
    keys = keys.flatten
    self.keys.each { |k| self.delete(k) unless keys.include?(k) }
    self
  end

  def transform_keys(trans_hash)
    self.dup.transform_keys!(trans_hash)
  end
  def transform_keys!(trans_hash)
    raise ArgumentError, "transform_keys takes a single hash argument" unless trans_hash.is_a?(Hash)
    self.each_key do |k|
      self[trans_hash.has_key?(k) ? trans_hash[k] : k] = self.delete(k)
    end
    self
  end
end
