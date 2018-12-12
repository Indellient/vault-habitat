# # encoding: utf-8

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# Make sure the hab-sup process is running
describe processes(Regexp.new('hab-sup run')) do
  it { should exist }
end

# Make sure the consul process is running
describe processes(Regexp.new('vault')) do
  it { should exist }
end

# Basic vault status
describe command("VAULT_TOKEN=$(cat /hab/svc/vault/data/root_token) VAULT_ADDR=http://127.0.0.1:8200 hab pkg exec #{ENV['HAB_ORIGIN']}/vault vault status") do
  its('stdout') { should match /Initialized(\s+)true/ }
  its('stdout') { should match /Sealed(\s+)false/ }
  its('stdout') { should match /HA Enabled(\s+)true/ }
  its('stdout') { should match /HA Mode(\s+)(active|standby)/ }
end
