class CarsController < ApplicationController
  # Action pour afficher toutes les voitures
  # GET /cars
  def index
    # Initialiser la requête de base
    @cars = Car.all
    @car = Car.new
    
    # Filtrer par localisation si spécifiée (sans geocoder)
    if params[:query].present?
      @cars = @cars.by_location(params[:query])
    end
    
    # Filtrer par disponibilité de dates si spécifiées
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      
      # Exclure les voitures qui ont des réservations pendant cette période
      @cars = @cars.where.not(id: Rental.where(
        "(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date >= ? AND end_date <= ?)",
        start_date, start_date, end_date, end_date, start_date, end_date
      ).select(:car_id))
    end
    
    # Filtrer par prix minimum si spécifié
    if params[:price_min].present?
      @cars = @cars.where("price >= ?", params[:price_min])
    end
    
    # Filtrer par kilométrage minimum si spécifié
    if params[:km_min].present?
      @cars = @cars.where("km >= ?", params[:km_min])
    end
    
    # Filtrer par phase si spécifiée
    if params[:phase].present?
      @cars = @cars.where(phase: params[:phase])
    end
    
    # Filtrer par année si spécifiée
    if params[:year].present?
      @cars = @cars.where(year: params[:year])
    end
    
    # Préparer les marqueurs pour la carte
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
    Rails.logger.debug "Filtered cars count: #{@cars.count}"
    Rails.logger.debug "Markers: #{@markers.inspect}"
  end

  # Action pour afficher le formulaire de création d'une nouvelle voiture
  # GET /cars/new
  def new
    @car = Car.new
    
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "form", locals: { car: @car } }
    end
  end

  # Action pour afficher les détails d'une voiture spécifique
  # GET /cars/:id
  def show
    @car = Car.find(params[:id])  # Trouve la voiture par son ID
    @rental = Rental.new
  end

  # Action pour créer une nouvelle voiture
  # POST /cars
   def create
    @car = Car.new(car_params)
    @car.user = current_user

    respond_to do |format|
      if @car.save
        format.html { redirect_to cars_path, notice: "Car was successfully created." }
        format.json { render json: { success: true, redirect: cars_path }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @car.errors }, status: :unprocessable_entity }
      end
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
      redirect_to rentals_path(tab: "loueur"), alert: "You are not authorized to edit this car."
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
      return redirect_to rentals_path(tab: "loueur"), alert: "You are not authorized to edit this car."
    end

    # Tentative de mise à jour avec les paramètres filtrés
    if @car.update(car_params)
      # Redirection vers la page de détails de la voiture avec message de succès
      redirect_to rentals_path(tab: "loueur"), notice: 'Car was successfully updated.'
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

  def validate_step
    @car = Car.new(car_params)
    
    # Valider uniquement les champs de l'étape actuelle
    step = params[:step].to_i
    fields_to_validate = case step
                         when 0
                           [:phase, :km, :year]
                         when 1
                           [:price, :location]
                         when 2
                           [:photos, :description]
                         end
    
    valid = fields_to_validate.all? { |field| @car.valid?(field) }
    
    render json: {
      valid: valid,
      errors: @car.errors.messages.slice(*fields_to_validate)
    }
  end

  def save_draft
    if params[:car_id].present?
      @car = Car.find(params[:car_id])
      @car.assign_attributes(car_params)
    else
      @car = Car.new(car_params)
      @car.user = current_user
      @car.draft = true
    end
    
    if @car.save(validate: false)  # Ne pas valider pour permettre les sauvegardes partielles
      render json: { success: true, car_id: @car.id }
    else
      render json: { success: false, errors: @car.errors.full_messages }
    end
  end

  private
    # Méthode privée pour filtrer les paramètres autorisés
    # Cette méthode est utilisée pour prévenir les attaques de type mass assignment
    def car_params
      # Assurez-vous que tous les paramètres nécessaires sont autorisés
      params.require(:car).permit(:phase, :description, :year, :km, :price, :location, images: [])
    end
end
