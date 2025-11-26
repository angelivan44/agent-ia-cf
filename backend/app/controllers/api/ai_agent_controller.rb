class Api::AiAgentController < ApplicationController
  def ai_agent

    render json: { message: params[:promp] }
  end

  private

  def ai_agent_params
    params.permit(:promp)
  end
end
