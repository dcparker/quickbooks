# This is serious super-magic code... :P
# Array and Hash are extended only slightly, with methods that will extend an Array object to be kept unique, or
# a Hash object to be kept in a given order or else in the order keys are defined; or an Array or Hash object just to retain
# the ordered-ness of contained hashes.
# 'slashing' in Array and Hash is the idea that multi-dimensional hashes and arrays could be represented by a key split by '/'s.
# In this way we can sort a multi-dimensional hash by a multi-dimensional array (to give the hash order), and then blow up the
# slash keys into actual multi-dimensional hashes.
class String
  def slashed?
    self =~ /\//
  end
  def flatten_slashes
    self
  end
  def expand_slashes(seed=nil,overwrite=false)
    return self.dup if !slashed? && seed.nil?

    hsh = seed.nil? ? [] : (seed.is_a?(Array) ? seed : [seed])
    leaf = hsh
    slashed = self
    s = nil
    redoing = false
    while(slashed)
      s, slashed = slashed.split('/',2) unless redoing
      redoing = false

      # break when we can't go further

      # If leaf is a hash, continue into hash[s] if an array, or if a hash and !slashed.nil?.
      if leaf.is_a?(Hash)
        if leaf.has_key?(s)
          if leaf[s].is_a?(Array) || (leaf[s].is_a?(Hash) && slashed.to_s.split('/').length > 1)
            leaf = leaf[s]
          else
            break
          end
        else
          break
        end


      # If leaf is an array, continue only if !slashed.nil? AND an included hash contains the key
      elsif leaf.is_a?(Array)
        if !slashed.nil? && ((false) || h = leaf.reject {|e| !e.is_a?(Hash)}.reject {|e| !e.has_key?(s)}[-1])
          leaf = h
          redoing = true
          redo
        else
          break
        end
      end
    end

    # now we have leaf, which is where we need to append our value(s); s, the next segment, and slashed, which is all the rest of the segments
    if slashed
      case leaf
      when Hash
        if leaf.has_key?(s)
          if overwrite
            leaf[s] = slashed.expand_slashes
          else
            if leaf[s].is_a?(Array)
              leaf[s] = leaf[s] + slashed.expand_slashes
            else
              leaf[s] = [leaf[s], slashed.expand_slashes]
            end
          end
        else
          leaf[s] = slashed.expand_slashes
        end
      when Array
        if overwrite && leaf.include?(s)
          leaf[leaf.index(s)] = {s => slashed.expand_slashes}
        else
          if leaf[-1].is_a?(Hash)
            leaf[-1][s] = slashed.expand_slashes
          else
            leaf << {s => slashed.expand_slashes}
          end
        end
      end


    # There's no more, just the end value. leaf shouldn't be a hash in this case
    else
      case leaf
      when Hash
        # If leaf IS a hash, it must be the root hsh. In that case, it becomes obvious we need hsh to be an array, not a hash
        hsh = [hsh, s]
      when Array
        leaf << s unless overwrite && leaf.include?(s)
      end
    end

    hsh.length < 2 ? hsh[0] : hsh
  end
end
class Array
  def slashed?
    any? {|e| e.to_s =~ /\//}
  end
  def slashed!
    expand_slashes!
    SlashedArray.prepare_for_overwrites!(self) unless self.respond_to?(:append_unslashed)
    extend SlashedArray
  end
  def flatten_slashes!
    replace(flatten_slashes)
  end
  def flatten_slashes
    ary = []
    self.each do |e|
      if e.is_a?(Hash)
        e.flatten_slashes.each do |k,v|
          if v.is_a?(Array)
            v.each do |i|
              ary << k.to_s+'/'+i.to_s
            end
          else
            ary << k.to_s+'/'+v.to_s
          end
        end
      else
        ary << e
      end
    end
    ary
  end
  def expand_slashes!(seed=nil)
    h = expand_slashes(seed)
    replace(h.is_a?(Array) ? h : [h])
  end
  def expand_slashes(seed=nil)
    return self.dup if !slashed? && seed.nil?
    hsh = seed.nil? ? [] : (seed.is_a?(Array) ? seed : [seed])
    self.each do |e|
      if !e.is_a?(String)
        hsh << e
        next
      end
      # Find as far as possible in the already-created structure,
      # then create new structure by either adding to an existing hash value, array, or by calling string.expand_slashes
      e.expand_slashes(hsh)
    end
    hsh.length < 2 ? hsh[0] : hsh
  end
  def step_into_slash(key)
    reject {|e| e !~ Regexp.new("^#{key}")}.collect {|e| e.split('/',2)[1]}
  end

  def keep_unique!
    uniq!
    UniqueArray.prepare_for_overwrites!(self) unless self.respond_to?(:push_without_unique)
    extend UniqueArray
  end
  def ordered!(*keys_in_order)
    OrderedArray.new(*keys_in_order).replace(self)
  end
  def ordered?
    false
  end
  def ordered_propogated!
    OrderedHashPropogator.prepare_for_overwrites!(self) unless self.respond_to?(:push_without_unique)
    extend OrderedHashPropogator
  end
end
module SlashedArray
  def self.prepare_for_overwrites!(ary)
    class << ary
      alias :append_unslashed :<<
      alias :push_unslashed :push
      alias :unshift_unslashed :unshift
      alias :set_value_unslashed :[]=
    end
  end

  # Currently this doesn't do anything. :P
  def keep_unique!
    @keep_unique = true
  end

  def flattened
    flatten_slashes
  end
  def unshift(v)
    if v.slashed?
      self.expand_slashes(v)
    else
      unshift_unslashed(v)
    end
  end
  def push(v)
    if v.slashed?
      v.expand_slashes(self)
    else
      push_unslashed(v)
    end
  end
  def <<(v)
    push(v)
  end
  def []=(i,v)
    if v.slashed?
      v.expand_slashes(self,true)
    else
      set_value_unslashed(i,v)
    end
  end
end
# In reality, this is just holding the Order information for any hashes it might contain.
class OrderedArray < Array
  def initialize(*keys_in_order)
    @keys_in_order = keys_in_order.flatten.compact.keep_unique!
  end

  def ordered!(*keys_in_order)
    false
  end
  def ordered?
    true
  end
end
module UniqueArray
  def self.prepare_for_overwrites!(ary)
    class << ary
      alias :push_without_unique :push
      alias :unshift_without_unique :unshift
      alias :append_without_unique :<<
      # This makes sure whatever kind of array (regular, slashed_structure, etc) it is,
      # keep_unique! will keep it unique at the type it was when it was told to stay unique.
      alias :_snapshot_include? :include?
    end
  end
  def self.new
    [].keep_unique!
  end

  def push(*args)
    args.each do |arg|
      push_without_unique(arg) unless _snapshot_include?(arg)
    end
  end
  def unshift(*args)
    args.each do |arg|
      unshift_without_unique(arg) unless _snapshot_include?(arg)
    end
  end
  def <<(*args)
    args.each do |arg|
      append_without_unique(arg) unless _snapshot_include?(arg)
    end
  end
end

class Hash
  def slashed?
    keys.any? {|k| k.to_s =~ /\//}
  end
  def slashed!
    expand_slashes!
    SlashedHash.prepare_for_overwrites!(self) unless self.respond_to?(:set_value_unslashed)
    extend SlashedHash
  end
  def flatten_slashes
    self.dup.flatten_slashes!
  end
  def flatten_slashes!
    hsh = {} #.ordered!
    self.each do |k,v|
      if v.is_a?(Hash)
        v.flatten_slashes.each do |vk,vv|
          hsh[k.to_s+'/'+vk.to_s] = vv
        end
      elsif v.is_a?(Array)
        hsh[k] = v.flatten_slashes
      else
        hsh[k] = v
      end
    end
    hsh
  end
  def expand_slashes(seed=nil)
    return self.dup if empty?
    [self.dup].flatten_slashes.expand_slashes(seed)
  end
  def expand_slashes!(seed=nil)
    return self if empty?
    replace(expand_slashes(seed))
  end

  def ordered!(*keys_in_order)
    OrderedHash.new(*keys_in_order).replace(self)
  end
  def ordered?
    false
  end
  def slash_camelize_keys!(specials={})
    self.each_key do |k|
      self[specials.has_key?(k) ? specials[k] : (k.is_a?(Symbol) ? k.to_s.camelize.to_sym : k.split('/').map {|e| e.camelize}.join('/'))] = self.delete(k)
    end
    self
  end
end
module SlashedHash
  def self.prepare_for_overwrites!(hsh)
    class << hsh
      # alias :append_value_unslashed :<<
      alias :set_value_unslashed :[]=
      alias :get_value_unslashed :[]
    end
  end

  def flattened
    flatten_slashes
  end
  def <<(v)
    v.expand_slashes(self)
  end
  def [](k)
    if k.slashed?
      leaf = self
      k.split('/').each do |s|
        leaf = leaf[s]
        break unless leaf.is_a?(Hash)
      end
      leaf
    else
      get_value_unslashed(k)
    end
  end
  def []=(k,v)
    if k.slashed?
      (k+'/'+v).expand_slashes(self,true)
    else
      set_value_unslashed(k,v)
    end
  end
end

class OrderedHash < Hash
  alias :unordered_keys :keys
  alias :unordered_values :values
  alias :each_unordered :each
  alias :set_value :[]=
  alias :get_value :[]

  def initialize(*keys_in_order, &block)
    super(&block)
    @keys_in_order = keys_in_order.flatten + (self.keys.reject {|e| !keys_in_order.flatten.include?(e) }).compact.keep_unique!
  end

  def dup
    Hash.new.replace(self)
  end

  def ordered!
    false
  end
  def ordered?
    true
  end

  def keys
    expand_slashes.keys.sort {|a,b| @keys_in_order.index(a) <=> @keys_in_order.index(b)}
  end
  def values
    self.keys.collect {|k| self[k]}
  end
  def each(&block)
    self.keys.each do |k|
      block.call(k, self[k])
    end
  end
  def each_key(&block)
    self.keys.each &block
  end
  def each_value(&block)
    self.values.each &block
  end
  def []=(k,v)
    @keys_in_order << k
    set_value(k,v)
  end
  def [](k)
    # If the value being retrieved is a hash or an array, we need to make sure it's an Ordered one.
    v = get_value(k)
    if (v.is_a?(Hash) || v.is_a?(Array)) && !v.ordered?
      child_order = @keys_in_order.step_into_slash(k)
      v = self[k] = v.ordered!(child_order)
    end
    v
  end
end
