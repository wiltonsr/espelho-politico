class QuizController < ApplicationController

  def index
  end

  def create
    begin
      @proposition = randomize_propositions(Proposition.all)[0]
    end while @proposition.explanation.size <= 5
  end

  def randomize_propositions(array_propositions)
    array_propositions.sort_by { rand }
  end

end