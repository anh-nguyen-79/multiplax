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

  
 resources :cars, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      get :nearby
    end
  end
  resources :rentals, only: [
    :index,
    :show,
    :new,
    :create,
    :edit,
    :update,
    :destroy
  ] do
    member do
      patch :cancel
    end
  end


  # Définition des routes pour les voitures
  # Les actions autorisées sont:
  # - index: Afficher la liste de toutes les voitures
  # - show: Afficher les détails d'une voiture spécifique
  # - new: Afficher le formulaire de création d'une nouvelle voiture
  # - create: Traiter la soumission du formulaire de création
  # - edit: Afficher le formulaire d'édition d'une voiture existante
  # - update: Traiter la soumission du formulaire d'édition
  # - destroy: Supprimer une voiture existante
 

  # Route explicite vers la page d'accueil
  get '/home', to: 'pages#home'

end
