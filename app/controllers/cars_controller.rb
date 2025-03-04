class CarsController < ApplicationController
  # Action pour afficher toutes les voitures
  # GET /cars
  def index
    @cars = Car.all  # Récupère toutes les voitures de la base de données
  end

  # Action pour afficher le formulaire de création d'une nouvelle voiture
  # GET /cars/new
  def new
    @car = Car.new  # Initialise un nouvel objet Car pour le formulaire
  end

  # Action pour afficher les détails d'une voiture spécifique
  # GET /cars/:id
  def show
    @car = Car.find(params[:id])  # Trouve la voiture par son ID
  end

  # Action pour créer une nouvelle voiture
  # POST /cars
  def create
    @car = Car.new(car_params)
    
    # Associer l'utilisateur actuel à la voiture si l'utilisateur est connecté
    @car.user = current_user if user_signed_in?
    
    if @car.save
      redirect_to cars_path, notice: 'Car was successfully created.'
    else
      # Ajouter un message flash d'erreur
      flash.now[:alert] = "There were errors in your submission. Please check the form."
      render :new, status: :unprocessable_entity
    end
  end

  private
    # Méthode privée pour filtrer les paramètres autorisés
    # Cette méthode est utilisée pour prévenir les attaques de type mass assignment
    def car_params
      params.require(:car).permit(:phase, :description, :year, :km, :price, :location, images: [])
    end
end
