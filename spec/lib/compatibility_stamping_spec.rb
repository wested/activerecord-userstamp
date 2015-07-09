require 'rails_helper'

RSpec.describe 'Compatibility Stamping', type: :model do
  before do
    create_test_models
    ActiveRecord::Userstamp.compatibility_mode = true
    Comment.delete_all
    @first_comment = Comment.create!(:comment => 'a comment', :post => @first_post)
  end

  context 'when creating an object' do
    context 'when the stamper is an ID' do
      it 'sets the correct stamper' do
        Person.stamper = @nicole.id
        expect(Person.stamper).to eq(@nicole.id)

        comment = Comment.create(:comment => "Test Comment - 2")
        expect(comment.created_by).to eq(@nicole.id)
        expect(comment.updated_by).to eq(@nicole.id)
        expect(comment.creator).to eq(@nicole)
        expect(comment.updater).to eq(@nicole)
      end
    end

    context 'when the stamper is an object' do
      it 'sets the correct stamper' do
        expect(Person.stamper).to eq(@delynn.id)

        comment = Comment.create(:comment => "Test Comment")
        expect(comment.created_by).to eq(@delynn.id)
        expect(comment.updated_by).to eq(@delynn.id)
        expect(comment.creator).to eq(@delynn)
        expect(comment.updater).to eq(@delynn)
      end
    end
  end

  context 'when updating an object' do
    context 'when the stamper is an object' do
      it 'sets the correct creator and updater' do
        Person.stamper = @nicole
        expect(Person.stamper).to eq(@nicole.id)

        @first_comment.comment << " - Updated"
        @first_comment.save
        @first_comment.reload
        expect(@first_comment.created_by).to eq(@delynn.id)
        expect(@first_comment.updated_by).to eq(@nicole.id)
        expect(@first_comment.creator).to eq(@delynn)
        expect(@first_comment.updater).to eq(@nicole)
      end
    end

    context 'when the stamper is an ID' do
      it 'sets the correct creator and updater' do
        Person.stamper = @nicole.id
        expect(Person.stamper).to eq(@nicole.id)

        @first_comment.comment << " - Updated"
        @first_comment.save
        @first_comment.reload
        expect(@first_comment.created_by).to eq(@delynn.id)
        expect(@first_comment.updated_by).to eq(@nicole.id)
        expect(@first_comment.creator).to eq(@delynn)
        expect(@first_comment.updater).to eq(@nicole)
      end
    end
  end
end
