class InvitationController < ApplicationController

  before_action :set_city
  before_action :find_invitation

  def show
    @invitable = @invitation.invitable
    @city = @invitable.city

    return render 'invitation/workshop' if @invitable.is_a? Event
  end

  def update
    if @invitation.update_attributes(invitation_params)
      flash[:notice] = "Thank you for your response."

      AdminMailer.notify(@invitation).deliver
      @invitation.send_confirmation if @invitation.attending
    end

    redirect_to @invitation
  end

  private

  def find_invitation
    @invitation = Invitation.find_by_token params[:token]
  end

  def set_city
    @city = City.find_by_slug(params[:city_id])
  end

  def invitation_params
    params.require(:invitation).permit(:attending, :waiting_list, :comment)
  end

end
