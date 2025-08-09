require 'rails_helper'

RSpec.describe 'Health', type: :request do
  describe 'GET /health' do
    it 'returns ok json' do
      get '/health'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('ok')
      expect(json).to have_key('commit')
      expect(json).to have_key('time')
    end
  end
end


