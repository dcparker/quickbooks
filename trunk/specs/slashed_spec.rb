require File.dirname(__FILE__) + '/spec_helper'
require 'quickbooks/structure'

describe "String Slashed Structuring" do
  it "should expand a simple string" do
    'a/b/c'.expand_slashes.should == {'a' => {'b' => 'c'}}
  end
  it "should expand a simple string with a seed hash" do
    'a/b/c'.expand_slashes({'a' => 'c'}).should == {'a' => ['c', {'b' => 'c'}]}
  end
end

describe "Array Slashed Structuring" do
  it "should expand an array to a hash containing an array" do
    ['a/b', 'a/c'].expand_slashes.should == {'a' => ['b', 'c']}
  end
  it "should expand an array to a hash containing a hash" do
    ['a/b', 'b/c'].expand_slashes.should == {'a' => 'b', 'b' => 'c'}
  end
  it "should expand an array to a hash containing an array and a hash" do
    ['a/b', 'a/c/d'].expand_slashes.should == {'a' => ['b', {'c' => 'd'}]}
  end
  it "should expand an array to a hash containing a hash and an array" do
    ['a/b', 'b/c', 'b/d'].expand_slashes.should == {'a' => 'b', 'b' => ['c', 'd']}
  end
  it "should expand an array to a hash containing an array with a hash containing an array" do
    ['a/b', 'b/c/d', 'b/c/e', 'b/d'].expand_slashes.should == {'a' => 'b', 'b' => [{'c' => ['d', 'e']}, 'd']}
  end
  it "should expand an array to a hash containing an array with a hash containing an array" do
    ['a/b', 'b/c/d', 'b/c/e', 'b/d', 'b/c/d'].expand_slashes.should == {'a' => 'b', 'b' => [{'c' => ['d', 'e', 'd']}, 'd']}
  end
  it "should flatten an array to a hash containing an array" do
    [{'a' => ['b', 'c']}].flatten_slashes.sort.should == ['a/b', 'a/c'].sort
  end
  it "should flatten an array to a hash containing a hash" do
    [{'a' => 'b', 'b' => 'c'}].flatten_slashes.sort.should == ['a/b', 'b/c'].sort
  end
  it "should flatten an array to a hash containing an array and a hash" do
    [{'a' => ['b', {'c' => 'd'}]}].flatten_slashes.sort.should == ['a/b', 'a/c/d'].sort
  end
  it "should flatten an array to a hash containing a hash and an array" do
    [{'a' => 'b', 'b' => ['c', 'd']}].flatten_slashes.sort.should == ['a/b', 'b/c', 'b/d'].sort
  end
  it "should flatten an array to a hash containing an array with a hash containing an array" do
    [{'a' => 'b', 'b' => [{'c' => ['d', 'e']}, 'd']}].flatten_slashes.sort.should == ['a/b', 'b/c/d', 'b/c/e', 'b/d'].sort
  end
  it "should flatten an array to a hash containing an array with a hash containing an array" do
    [{'a' => 'b', 'b' => [{'c' => ['d', 'e', 'd']}, 'd']}].flatten_slashes.sort.should == ['a/b', 'b/c/d', 'b/c/e', 'b/d', 'b/c/d'].sort
  end
end

describe "Hash Slashed Structuring" do
  it "should expand a simple hash" do
    {'a' => 'b', 'a/c' => 'd'}.expand_slashes.should == {'a' => ['b', {'c' => 'd'}]}
  end
end

describe "Ordered Slashed Hash" do
  it "should keep the order" do
    h = {}.ordered!.slashed!
    h['a'] = 'b'
    h['b/c'] = 'd'
    h << 'b/c/e'
    h << 'b/g/a'
    h << 'b/f/a'
    h['c'] = 'ii'
    # => {"a"=>"b", "b"=>{"c"=>["d", "e"], "g"=>"a", "f"=>"a"}, "c"=>"ii"}
    h.keys.should == ['a', 'b', 'c']
    h['b'].keys.should == ['c', 'g', 'f']
  end
end
