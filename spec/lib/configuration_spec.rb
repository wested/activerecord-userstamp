require 'rails_helper'

RSpec.describe 'Configuration' do
  describe '.configure' do
    it 'yields a block with the config argument' do
      block = nil
      ActiveRecord::Userstamp.configure do |config|
        block = config
      end
      expect(block).to be(ActiveRecord::Userstamp::Configuration)
    end
  end
end
