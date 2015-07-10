require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  controller do
  end

  before(:each) do
    reset_to_defaults
  end

  context 'when updating a User' do
    it 'sets the correct updater' do
      request.session = { user_id: @hera.id }
      patch :update, id: @hera.id, user: { name: 'Different'}

      expect(response.status).to eq(200)
      expect(controller.instance_variable_get(:@user).name).to eq('Different')
      expect(controller.instance_variable_get(:@user).updater_id).to eq(@hera.id)
    end
  end

  context 'when handling multiple requests' do
    def simulate_second_request
      old_request_session = request.session
      request.session = { user_id: @zeus.id }

      post :update, id: @hera.id, user: { name: 'Different Second' }
      expect(controller.instance_variable_get(:@user).updater_id).to eq(@zeus.id)
    ensure
      request.session = old_request_session
    end

    it 'sets the correct updater' do
      request.session = { user_id: @hera.id }
      get :edit, id: @hera.id
      expect(response.status).to eq(200)

      simulate_second_request
    end
  end
end
