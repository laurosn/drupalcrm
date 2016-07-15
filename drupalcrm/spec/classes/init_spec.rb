require 'spec_helper'
describe 'drupalcrm' do
  context 'with default values for all parameters' do
    it { should contain_class('drupalcrm') }
  end
end
