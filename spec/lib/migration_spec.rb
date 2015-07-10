require 'rails_helper'

RSpec.describe 'Migration helpers', type: :model do
  class self::Random < ActiveRecord::Base
    stampable
  end
  subject { self.class::Random.new }

  temporary_table(:randoms) do |t|
    ActiveRecord::Userstamp.config.compatibility_mode = false
    t.userstamps
  end

  with_temporary_table(:randoms) do
    it 'has a creator_id association' do
      expect(subject.has_attribute?(:creator_id)).to be true
    end

    it 'has an updater_id association' do
      expect(subject.has_attribute?(:updater_id)).to be true
    end

    it 'has a deleter_id association' do
      expect(subject.has_attribute?(:deleter_id)).to be false
    end
  end
end
