class DataFormEntityResponsesController < ApplicationController
  # before_action :set_kommunity
  before_action :authenticate_user!, except: [:fill_form]
  before_action :set_data_form_entity



  # update or fill a data form for an event
  def fill_form
    @existing_response = Hash.new

    if (user_signed_in?)
      existing_response = DataFormEntityResponse.joins(:data_form_entity_response_group).includes(data_form_entity: {data_form: {questions: :question_type}}, data_form_entity_response_values: :question).where(data_form_entity_response_groups: {user_id: current_user.id}).last


      if existing_response &&  !@for_other_user
        @existing_response = existing_response.get_response_hash
      end
    end

    @event = @data_form_entity.entity.event



  end



  def submit_form

    if(user_signed_in? && !current_user.role?(:member, @kommunity.id))
      UserRolesUser.create(
          user: current_user,
          kommunity: @kommunity,
          user_role: UserRole.find_by_name(:member)
      )
    end

    DataFormEntityResponse.create_or_find_user_response(
        @data_form_entity,
        current_user,
        params[:data_form_entity_response],
        from_organizer = true
    )

  end



  private

  def set_data_form_entity
    # @event = Event.friendly.find(params[:event_id])

    @data_form_entity = DataFormEntity.find(params[:data_form_entity_id])
    @for_other_user = (params[:for_other_user] == 'true')

  end




end