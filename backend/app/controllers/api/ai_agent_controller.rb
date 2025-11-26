class Api::AiAgentController < ApplicationController
  def ai_agent

    response = GeminiApiService.chat(params[:prompt])

    render json: { message: response }
  end

  private

  def ai_agent_params
    params.permit(:prompt)
  end
end
