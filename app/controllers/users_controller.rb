# Contrôleur qui gère les actions liées aux utilisateurs
class UsersController < ApplicationController
  # ........
  def create
    # Initialise un nouvel utilisateur avec les paramètres fournis
    @user = User.new(user_params)
    if @user.save
      # Redirige vers la page d'accueil avec un message de succès si l'enregistrement réussit
      redirect_to root_path, notice: 'Utilisateur créé avec succès.'
    else
      # Affiche à nouveau le formulaire avec les erreurs si l'enregistrement échoue
      render :new
    end
  end

  # Action pour afficher le formulaire de création d'un nouvel utilisateur
  def new
    # Initialise un nouvel objet utilisateur vide pour le formulaire
    @user = User.new
  end

  # Action pour supprimer le compte de l'utilisateur actuellement connecté
  def destroy
    # Supprime l'utilisateur actuel de la base de données
    current_user.destroy
    # Redirige vers la page d'accueil avec un message de confirmation
    redirect_to root_path, notice: 'Your account has been successfully deleted.'
  end

  private

  # Méthode privée pour filtrer les paramètres autorisés lors de la création/modification d'un utilisateur
  def user_params
    # Seuls les champs email, password et password_confirmation sont autorisés
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
