class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: [:show, :edit, :update, :destroy, :cancel]

  def index
    @rentals = current_user.rentals.order(start_date: :desc)
  end

  def show
    @rental = Rental.find(params[:id])
    @car = @rental.car
  end

  def new
    @car = Car.find_by(id: params[:car_id])
    @rental = Rental.new
  end

  def create
    @car = Car.find_by(id: rental_params[:car_id])
    unless @car
      redirect_to cars_path, alert: "🚨 Voiture introuvable !" and return
    end

    @rental = Rental.new(rental_params)
    @rental.user = current_user
    @rental.car = @car
    @rental.price = @car.price * (@rental.end_date - @rental.start_date).to_i

    if @rental.save
      flash[:notice] = "🚗 Réservation confirmée avec succès !"
      redirect_to rental_path(@rental)
    else
      flash[:alert] = @rental.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @car = @rental.car  # Récupère la voiture associée pour affichage
  end

  def update
    if @rental.update(rental_params)
      @rental.update(price: @rental.car.price * (@rental.end_date - @rental.start_date).to_i)  # Recalcule le prix
      flash[:notice] = "✅ mise à jour avec succès !"
      redirect_to rental_path(@rental)  # ✅ Reste sur la page de réservation
    else
      flash[:alert] = "❌ Erreur lors de la mise à jour, veuillez réessayer."
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @rental.destroy
    flash[:notice] = "🚨 Réservation supprimée définitivement !"
    redirect_to rentals_path
  end

  def cancel
    if @rental.status == "confirmed"
      @rental.update(status: "cancelled")
      flash[:notice] = "🚨 Réservation annulée avec succès !"
    else
      flash[:alert] = "❌ Cette réservation est déjà annulée."
    end
    redirect_to rental_path(@rental)
  end

  private
  def set_rental
    @rental = Rental.find(params[:id])
  end
  def rental_params
    params.require(:rental).permit(:start_date, :end_date, :price, :status, :user, :car_id)
  end
end
