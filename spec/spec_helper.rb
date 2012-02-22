require 'vcr'

#VCR.config do |c|
#  c.cassette_library_dir = 'spec/cassettes'
#  c.stub_with :fakeweb
#end

RSpec.configure do |c|
  c.color = true
#  c.extend VCR::RSpec::Macros
end
