class QuizController < ApplicationController
  def index
  end

  def create
    begin
      @proposition = randomize_propositions(Proposition.all)[0]
    end while @proposition.explanation.size <= 5

    if (params[:vote] && params[:vote].require(:approved?) != "Pular")
      Vote.create(vote_params)
    end
  end

  def randomize_propositions(array_propositions)
    array_propositions.sort_by { rand }
  end

  private
    def vote_params
      params.require(:vote).permit(:user_id, :proposition_id, :approved?)
    end
end
