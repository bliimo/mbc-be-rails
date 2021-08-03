class Api::V1::QuizGamesController < Api::V1::ApiController
  def index
    render json: QuizGame.all
  end

  def show
    render json: QuizGame.find(params[:id]).as_json(QuizGame.serializer)
  end

  def create 
    
  end

  private 


end
