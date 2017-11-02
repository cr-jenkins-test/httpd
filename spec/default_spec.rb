require 'spec_helper'

describe 'vandelay-httpd::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do
    end.converge(described_recipe)
  end

  it 'installs nginx' do
    expect(chef_run).to install_package('nginx')
  end
end
