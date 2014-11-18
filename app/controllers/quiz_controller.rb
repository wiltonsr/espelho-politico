class QuizController < ApplicationController

  def index
    @propositions_all = Proposition.all

    @propositions_all = randomize_propositions(@propositions_all)
    @proposition = @propositions_all[0]

  end

  def randomize_propositions(array_propositions)
    a = array_propositions
    a.sort_by { rand }
  end

end