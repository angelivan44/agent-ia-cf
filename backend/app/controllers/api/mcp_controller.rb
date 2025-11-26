class Api::McpController < ApplicationController
  def tools
    tools = McpTools.list_tools
    render json: { tools: tools }
  end

  def call
    tool_name = params[:tool_name]
    arguments = params[:arguments] || {}

    result = McpTools.call_tool(tool_name, arguments)
    
    if result[:error]
      render json: result, status: :not_found
    elsif result[:isError]
      render json: result, status: :unprocessable_entity
    else
      render json: result
    end
  end
end

