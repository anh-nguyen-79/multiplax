class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home]

  def home
    # Logique pour la page d'accueil
  end

end
