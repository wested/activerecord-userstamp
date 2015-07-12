require 'rails_helper'

RSpec.describe 'Stamper' do
  describe '.model_stamper' do
    it 'can only be included once' do
      expect(User.singleton_class.included_modules.count(
        ActiveRecord::Userstamp::Stamper::InstanceMethods)).to eq(1)

      User.class_eval do
        stamper
      end

      expect(User.singleton_class.included_modules.count(
        ActiveRecord::Userstamp::Stamper::InstanceMethods)).to eq(1)
    end
  end

  describe '.stamper' do
    it 'defaults to nil' do
      User.reset_stamper
      expect(User.stamper).to be_nil
    end
  end

  describe '.stamper=' do
    it 'assigns the stamper' do
      stamper = User.new
      User.stamper = stamper
      expect(User.stamper).to eq(stamper)
    end

    context 'when the stamper is nil' do
      it 'resets the stamper' do
        User.stamper = nil
        expect(User.stamper).to be(nil)
      end
    end
  end

  describe '.reset_stamper' do
    it 'resets the stamper' do
      User.reset_stamper
      expect(User.stamper).to be_nil
    end
  end

  describe '.with_stamper' do
    context 'when within the block' do
      it 'uses the correct stamper' do
        stamper = User.create(name: 'Joel')
        User.with_stamper(stamper) do
          expect(User.stamper).to eq(stamper)
        end
      end
    end

    context 'when exiting the block' do
      it 'restores the stamper' do
        expect do
          User.with_stamper(User.create(name: 'Joel')) do
          end
        end.not_to change { User.stamper }
      end
    end
  end
end
