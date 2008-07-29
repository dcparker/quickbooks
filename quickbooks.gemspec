Gem::Specification.new do |s|
  s.name = 'quickbooks'
  s.version = "0.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2.0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Parker"]
  s.date = %q{2008-07-25}

  s.summary = "A Ruby implementation of the QuickBooks SDK (QBXML) and the QuickBooks Merchant Services SDK (QBMSXML)."
  s.description = "Read and Write QuickBooks data through the QuickBooks API using WIN32OLE and QBXML. Other connection types to come."

  s.email = ["gems@behindlogic.com"]
  s.extra_rdoc_files = ["History.txt", "LICENSE", "Manifest.txt", "README"]
  s.files = [
    "History.txt",
    "lib/qbxml/request.rb",
    "lib/qbxml/response.rb",
    "lib/qbxml/support.rb",
    "lib/qbxml.rb",
    "lib/quickbooks/adapters/ole_adapter.rb",
    "lib/quickbooks/adapters/qbxml_debug_adapter.rb",
    "lib/quickbooks/base.rb",
    "lib/quickbooks/model.rb",
    "lib/quickbooks/models/common/address.rb",
    "lib/quickbooks/models/common/all_refs.rb",
    "lib/quickbooks/customer/credit_card_info.rb",
    "lib/quickbooks/customer.rb",
    "lib/quickbooks/deleted.rb",
    "lib/quickbooks/list_item.rb",
    "lib/quickbooks/transaction.rb",
    "lib/quickbooks/ruby_magic.rb",
    "lib/quickbooks.rb",
    "LICENSE",
    "README",
    "specs/qbxml_spec.rb",
    "specs/quickbooks_spec.rb",
    "specs/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/dcparker/quickbooks}
  s.post_install_message = %q{
    For more information on quickbooks, see http://github.com/dcparker/quickbooks
  }
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = 'quickbooks'
  s.rubygems_version = %q{1.2.0}
  s.test_files = ["specs/qbxml_spec.rb", "specs/quickbooks_spec.rb", "specs/spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end