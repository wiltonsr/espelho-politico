class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:session][:username], params[:session][:password])

    if user.nil?
      flash.now[:error] = "Dados inválidos! Verifique os seus dados e tente novamente."
      render :new
    else
      sign_in user
      redirect_to_user
    end

    def destroy
      sign_out
      rediret_to_sign_path
    end
  end