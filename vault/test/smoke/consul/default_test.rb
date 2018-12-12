# # encoding: utf-8

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# Make sure the hab-sup process is running
describe processes(Regexp.new('hab-sup run')) do
  it { should exist }
end

# Make sure the consul process is running
describe processes(Regexp.new('consul')) do
  it { should exist }
end

# Members
describe command('hab pkg exec bluepipeline/consul consul members') do
  its('stdout') { should match /172.17.0.2:8301(.*)alive(.*)server(.*)east-kitchen/ }
  its('stdout') { should match /172.17.0.3:8301(.*)alive(.*)server(.*)east-kitchen/ }
  its('stdout') { should match /172.17.0.4:8301(.*)alive(.*)server(.*)east-kitchen/ }
  its('stdout') { should match /172.17.0.5:8301(.*)alive(.*)server(.*)east-kitchen/ }
end
