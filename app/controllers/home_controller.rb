class HomeController < ApplicationController
  before_action :access_allowed?, unless: :devise_controller?



  def home

    @upcoming_events = Event.includes(event_data_form_entity_groups: :data_form_entities).upcoming

  end



end
