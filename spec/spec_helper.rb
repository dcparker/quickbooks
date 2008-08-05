# In order to run these tests you need to have a test Company file. I didn't include one because it would take up the bulk of the size
# of an svn checkout. Just create a new company and open it. Make a couple people, and change some of the tests to include the right
# names or whatever they reference. Sorry, it's not necessarily meant to be easy.

$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'quickbooks'
require File.dirname(__FILE__) + '/example_responses'
