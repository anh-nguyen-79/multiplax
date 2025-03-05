class CarsController < ApplicationController
  # Action pour afficher toutes les voitures
  # GET /cars
  def index
    @cars = Car.all
    # @rentals = current_user.rentals if user_signed_in?
    # Vérifier si des voitures ont des coordonnées
    @markers = []
    
    if @cars.any?
      geocoded_cars = @cars.geocoded
      
      if geocoded_cars.any?
        @markers = geocoded_cars.map do |car|
          {
            lat: car.latitude,
            lng: car.longitude,
            info_window_html: render_to_string(partial: "info_window", locals: {car: car})
          }
        end
      end
    end
    
    # Ajouter un log pour le débogage
    Rails.logger.debug "Markers: #{@markers.inspect}"
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

  # Action pour afficher le formulaire d'édition d'une voiture
  # GET /cars/:id/edit
  def edit
    # Récupère la voiture à éditer par son ID
    @car = Car.find(params[:id])

    # Vérification de sécurité: seul le propriétaire peut éditer sa voiture
    # Si l'utilisateur n'est pas le propriétaire, redirection avec message d'erreur
    unless @car.user == current_user
      redirect_to cars_path, alert: "You are not authorized to edit this car."
    end
  end

  # Action pour mettre à jour une voiture existante
  # PATCH/PUT /cars/:id
  def update
    # Récupère la voiture à mettre à jour par son ID
    @car = Car.find(params[:id])

    # Vérification de sécurité: seul le propriétaire peut mettre à jour sa voiture
    # Si l'utilisateur n'est pas le propriétaire, redirection avec message d'erreur
    # Le 'return' arrête l'exécution de la méthode immédiatement
    unless @car.user == current_user
      return redirect_to cars_path, alert: "You are not authorized to edit this car."
    end

    # Tentative de mise à jour avec les paramètres filtrés
    if @car.update(car_params)
      # Redirection vers la page de détails de la voiture avec message de succès
      redirect_to car_path(@car), notice: 'Car was successfully updated.'
    else
      # En cas d'échec, affichage du formulaire avec les erreurs
      flash.now[:alert] = "There were errors in your submission. Please check the form."
      render :edit, status: :unprocessable_entity
    end
  end

  # Action pour supprimer une voiture
  # DELETE /cars/:id
  def destroy
    # Récupère la voiture à supprimer par son ID
    @car = Car.find(params[:id])

    # Vérification de sécurité: seul le propriétaire peut supprimer sa voiture
    unless @car.user == current_user
      return redirect_to cars_path, alert: "You are not authorized to delete this car."
    end

    # Suppression de la voiture
    @car.destroy

    # Redirection vers la liste des voitures avec message de confirmation
    redirect_to cars_path, notice: "Car was successfully deleted."
  end

  # GET /cars/nearby
  def nearby
    lng = params[:lng].to_f
    lat = params[:lat].to_f
    distance = params[:distance].to_f
    
    @cars = Car.near([lat, lng], distance)
    
    @markers = @cars.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {car: car})
      }
    end
    
    render json: @markers
  end

  private
    # Méthode privée pour filtrer les paramètres autorisés
    # Cette méthode est utilisée pour prévenir les attaques de type mass assignment
    def car_params
      params.require(:car).permit(:phase, :description, :year, :km, :price, :location, images: [])
    end
end
