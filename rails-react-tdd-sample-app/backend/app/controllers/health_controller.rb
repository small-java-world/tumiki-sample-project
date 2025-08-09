class HealthController < ApplicationController
  def index
    render json: {
      status: 'ok',
      commit: ENV['GIT_COMMIT_SHA'] || 'local',
      time: Time.now.utc.iso8601
    }
  end
end


