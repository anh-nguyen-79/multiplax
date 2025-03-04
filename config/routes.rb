Rails.application.routes.draw do
  # Configuration des routes pour l'authentification des vues (probablement un modèle legacy ou une erreur)
  devise_for :views
  
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

  # Définit les routes pour les actions utilisateur (création, nouveau, suppression)
  resources :users, only: [:new, :create, :destroy]

  # Route explicite vers la page d'accueil
  get '/home', to: 'pages#home'
end
