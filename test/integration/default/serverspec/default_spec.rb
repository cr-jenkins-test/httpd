require 'serverspec'
set :backend, :exec

describe command('curl http://localhost/') do
  its(:stdout) { is_expected.to match /Welcome to Vandelay Industries/ }
end
