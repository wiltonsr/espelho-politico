class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        sign_in user
        if params[:session][:remember_me] == '1'
          remember(user)
        else
          forget(user)
        end
        redirect_back_or user
      else
        message = "Conta não ativada"
        message += "Verifique o link de ativação no seu email"
        flash[:info] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Combinação de senha ou email inválida'
      render 'new'
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end
end