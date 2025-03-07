class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: [:show, :edit, :update, :destroy, :cancel]

  def index
    @upcoming_rentals = current_user.rentals.where("start_date >= ?", Date.today).order(:start_date)
    @past_rentals = current_user.rentals.where("end_date < ?", Date.today).order(end_date: :desc)
    @user_cars = current_user.cars
    @all_rentals = Rental.where(car_id: @user_cars.pluck(:id)).order(created_at: :desc) if @user_cars.present?
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
    @car = Car.find(params[:car_id])
    unless @car
      redirect_to cars_path, alert: "Car not found!" and return
    end

    @rental = Rental.new(rental_params)
    @rental.user = current_user
    @rental.car = @car
    @rental.price = @car.price * (@rental.end_date - @rental.start_date).to_i

    if @rental.save!
      flash[:notice] = "Booked!"
      redirect_to rentals_path(anchor: "loueur")
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
      flash[:notice] = "Updated !"
      redirect_to rental_path(@rental)  # ✅ Reste sur la page de réservation
    else
      flash[:alert] = "Oops something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @rental.destroy
    flash[:notice] = "Deletted !"
    redirect_to rentals_path
  end

  def cancel
    if @rental.status == "confirmed"
      @rental.update(status: "canceled")
      flash[:notice] = "Done!"
    else
      flash[:alert] = "This booking is already canceled."
    end
    redirect_to rentals_path
  end

  private
  def set_rental
    @rental = Rental.find(params[:id])
  end
  def rental_params
    params.require(:rental).permit(:start_date, :end_date, :price, :status, :user)
  end
end
