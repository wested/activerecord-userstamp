require 'rails_helper'

RSpec.describe ActiveRecord::Userstamp do
  it 'has a VERSION' do
    expect(ActiveRecord::Userstamp::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end
