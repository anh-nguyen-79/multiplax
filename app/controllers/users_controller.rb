class UsersController < ApplicationController
  # ...

  def create
    @user = User.new(user_params)
    if @user.save
      # Redirigez ou affichez un message de succès
      redirect_to root_path, notice: 'Utilisateur créé avec succès.'
    else
      # Rendre à la vue avec les erreurs
      render :new
    end
  end

  def new
    @user = User.new
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
