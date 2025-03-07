class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: [:show, :edit, :update, :destroy, :cancel, :validate, :reject]

  def index
    @upcoming_rentals = current_user.rentals.where("start_date >= ?", Date.today).order(:start_date)
    @past_rentals = current_user.rentals.where("end_date < ?", Date.today).order(end_date: :desc)
    @user_cars = current_user.cars
    @all_rentals = Rental.where(car_id: @user_cars.pluck(:id)).order(created_at: :desc) if @user_cars.present?
  end

  def show
    @car = @rental.car
  end

  def new
    @car = Car.find_by(id: params[:car_id])
    @rental = Rental.new
  end

  def create

    @car = Car.find(params[:car_id])


    @rental = Rental.new(rental_params)
    @rental.user = current_user
    @rental.car = @car
    @rental.price = @car.price * (@rental.end_date - @rental.start_date).to_i
    @rental.status = "pending"

    if @rental.save
      flash[:notice] = "✅ Request sent to the host!"
      redirect_to rentals_path

    else
      flash[:alert] = @rental.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @car = @rental.car
  end

  def update
    if @rental.update(rental_params)
      @rental.update(price: @rental.car.price * (@rental.end_date - @rental.start_date).to_i)
      flash[:notice] = "✅ Booking updated!"
      redirect_to rental_path(@rental)
    else
      flash[:alert] = "❌ Something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @rental.destroy
    flash[:notice] = "❌ Booking deleted!"
    redirect_to rentals_path
  end

  def cancel
    if @rental.status == "confirmed" 
      @rental.update(status: "canceled")
      flash[:notice] = "✅ Booking  canceled!"
    else
      flash[:alert] = "⚠️ Booking already canceled."
    end
    redirect_to rental_path
  end

  def validate
    if @rental.status == "pending"
      @rental.update(status: "confirmed")
      flash[:notice] = "✅ Booking successfully validated!"
    else
      flash[:alert] = "⚠️ This booking has already been processed."
    end
    redirect_to rentals_path(anchor: "loueur")
  end

  def reject
    if @rental.status == "pending"
      @rental.update(status: "rejected")
      flash[:notice] = "Booking request has been rejected!"
    else
      flash[:alert] = "This booking has already been processed."
    end
    redirect_to rentals_path(anchor: "loueur")
  end


  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def rental_params

    params.require(:rental).permit(:start_date, :end_date, :price, :status, :user)

  end
end
