# Contrôleur principal dont héritent tous les autres contrôleurs
class ApplicationController < ActionController::Base
    # Exécute la méthode configure_permitted_parameters avant les actions des contrôleurs Devise
    before_action :configure_permitted_parameters, if: :devise_controller?

  # Configure les paramètres autorisés pour Devise (authentification)
  def configure_permitted_parameters
    # Autorise le champ username lors de l'inscription
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])

    # Autorise le champ username lors de la mise à jour du compte
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  protected

  # Définit la redirection après déconnexion
  def after_sign_out_path_for(resource_or_scope)
    root_path # Redirige vers la page d'accueil après la déconnexion
  end
end
