require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  controller do
  end

  before(:each) do
    reset_to_defaults
  end

  context 'when updating a User' do
    it 'sets the correct updater' do
      patch :update, id: @hera.id, user: { name: 'Different'}
      expect(response.status).to eq(200)
      expect(controller.instance_variable_get(:@user).name).to eq('Different')
      expect(controller.instance_variable_get(:@user).updater).to eq(@hera)
    end
  end

  context 'when handling multiple requests' do
    def simulate_second_request
      patch :update, id: @hera.id, user: { name: 'Different Second' }
      expect(controller.instance_variable_get(:@user).updater).to eq(@zeus)
    end

    it 'sets the correct updater' do
      controller.session[:user_id] = @hera.id
      get :edit, :id => @hera.id
      expect(response.status).to eq(200)

      simulate_second_request
    end
  end
end
