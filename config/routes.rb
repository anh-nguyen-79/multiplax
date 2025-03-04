Rails.application.routes.draw do
  # Configuration des routes pour l'authentification des vues (probablement un modèle legacy ou une erreur)

  # Configuration des routes pour l'authentification des utilisateurs via Devise
  devise_for :users

  # Définit la page d'accueil de l'application
  root to: "pages#home"

  # Commentaire explicatif sur la définition des routes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Route pour vérifier l'état de santé de l'application
  # Peut être utilisée par les load balancers et les moniteurs de disponibilité
  get "up" => "rails/health#show", as: :rails_health_check

  # Commentaire explicatif sur la définition de la route racine
  # Defines the root path route ("/")
  # root "posts#index"

  # Définition des routes pour les voitures
  # Seules les actions index, show, new et create sont autorisées pour l'instant
  # Cela permet de:
  # - Voir la liste des voitures (index)
  # - Voir les détails d'une voiture (show)
  # - Afficher le formulaire de création (new)
  # - Créer une nouvelle voiture (create)
  resources :cars, only: [:index, :show, :new, :create]

  # Route explicite vers la page d'accueil
  get '/home', to: 'pages#home'

end
