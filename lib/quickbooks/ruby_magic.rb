# This file contains several little tidbits of magic that I've made to make certain things easier.
# See Object, Class, and Hash.
require 'rubygems'
require 'hash_magic'
require 'time'
require 'date'

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
    ary.flatten.include?(self)
  end
  # The opposite of is_one_of?
  def is_not_one_of?(*ary)
    !is_one_of?(ary)
  end

  # This way anything, even nil, can hold on to an error message to be picked up later.
  def errors
    @errors ||= []
  end
  def error?
    !@errors.empty?
  end
end

class Class
  # Returns the class name without the module names that precede it. I'm sure there's a builtin way to do this, but I couldn't find it and this works just as reliably!
  # Examples:
  # - Qbxml::Request.class_leaf_name # => 'Request'
  # - Quickbooks::Customer.class_leaf_name # => 'Customer'
  def class_leaf_name
    name.split('::')[-1]
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

  def slash_camelize_keys!(specials={})
    cam = slashed.flat
    cam.each_key do |k|
      cam[
        specials.has_key?(k) ? specials[k] : (k.is_a?(Symbol) ? k.to_s.camelize.to_sym : (k+' ').split('/').map {|e| e.camelize}.join('/')[0..-2])
      ] = cam.delete(k)
    end
    cam.slashed
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

  def underscore_keys(specials={})
    self.dup.underscore_keys!(specials)
  end
  def underscore_keys!(specials={})
    self.each_key do |k|
      self[specials.has_key?(k) ? specials[k] : k.underscore] = self.delete(k)
    end
    self
  end

  def stringify_values
    self.dup.stringify_values!
  end
  def stringify_values!
    self.each do |k,v|
      self[k] = v.to_s
    end
    self
  end

  # Returns values in this hash that are uniq or different than in the hash provided.
  # Example:
  #   {:a => :b, :f => :g, :z => :e}.diff(:a => :b, :f => :r, :u => :o) # => {:f => :g, :z => :e}
  def diff(hsh)
    dif = {}
    self.each do |k,v|
      dif[k] = v if !hsh.has_key?(k)
      if self[k].respond_to?(:===)
        dif[k] = v if !(self[k] === hsh[k])
      else
        dif[k] = v if !(self[k] == hsh[k])
      end
    end
    dif
  end

  def -(v)
    hsh = self.dup
    (v.is_a?(Array) ? v : [v]).each { |k| hsh.delete(k) }
    hsh
  end

  def only(*keys)
    keys.flatten.inject(dup.clear) {|h,(k,v)| h[k] = self[k]; h}
  end
  def only!(*keys)
    replace(only(*keys))
  end

  def reverse_merge(hsh)
    hsh.dup.merge(self)
  end
  def reverse_merge!(hsh)
    replace(hsh.merge(self))
  end

  def transform_keys(trans_hash,&block)
    dup.transform_keys!(trans_hash)
  end
  def transform_keys!(trans_hash,&block)
    raise ArgumentError, "transform_keys takes a single hash argument or a block" unless trans_hash.is_a?(Hash) || block_given?
    if block_given?
      each do |k,v|
        block.call(h,k,v)
      end
    else
      trans_hash.each do |k,v|
        self[v] = self.delete(k) if self.has_key?(k)
      end
    end
    self
  end
end

class Array
  def are_all?(klass)
    all? {|e| e.is_a?(klass)}
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
      (self[i].is_one_of?(values) || collect[i].is_one_of?(values)) ? i += 1 : self.slice!(i)
    end
    self
  end

  def camelize_values(specials={})
    self.dup.camelize_values!(specials)
  end
  def camelize_values!(specials={})
    self.each_with_index do |v,i|
      self[i] = specials.has_key?(v) ? specials[v] : (v.is_a?(Symbol) ? v.to_s.camelize.to_sym : v.camelize)
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
