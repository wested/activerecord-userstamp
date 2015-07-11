require 'rails_helper'

RSpec.describe 'Migration helpers', type: :model do
  context 'when default attribute names are used' do
    class self::DefaultRandom < ActiveRecord::Base
      stampable
    end
    subject { self.class::DefaultRandom.new }

    temporary_table(:default_randoms) do |t|
      t.userstamps(null: false)
    end

    with_temporary_table(:default_randoms) do
      it 'has a creator_id association' do
        expect(subject.has_attribute?(:creator_id)).to be true
        expect(subject.class.columns.find {|c| c.name == 'creator_id' }.null).to be false
      end

      it 'has an updater_id association' do
        expect(subject.has_attribute?(:updater_id)).to be true
        expect(subject.class.columns.find {|c| c.name == 'updater_id' }.null).to be false
      end

      it 'has a deleter_id association' do
        expect(subject.has_attribute?(:deleter_id)).to be true
        expect(subject.class.columns.find {|c| c.name == 'deleter_id' }.null).to be false
      end
    end
  end

  context 'when overridden attribute names are used' do
    before(:each) do
      ActiveRecord::Userstamp.configure do |config|
        config.creator_attribute = :created_by
        config.updater_attribute = :updated_by
        config.deleter_attribute = :deleted_by
      end
      class self.class::OverriddenRandom < ActiveRecord::Base
        stampable
      end
    end
    after(:each) do
      ActiveRecord::Userstamp.configure do |config|
        config.creator_attribute = :creator_id
        config.updater_attribute = :updater_id
        config.deleter_attribute = :deleter_id
      end
    end

    subject { self.class::OverriddenRandom.new }

    temporary_table(:overridden_randoms) do |t|
      t.userstamps
    end

    with_temporary_table(:overridden_randoms, :each) do
      it 'has a created_by attribute' do
        expect(subject.has_attribute?(:created_by)).to be true
      end

      it 'has an updated_by attribute' do
        expect(subject.has_attribute?(:updated_by)).to be true
      end

      it 'has a deleted_by attribute' do
        expect(subject.has_attribute?(:deleted_by)).to be true
      end
    end
  end
end
