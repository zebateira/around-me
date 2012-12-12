require 'json'

class EventsController < ApplicationController

  # GET /events/1
  # GET /events/1.json
  # GET /events/1.xml
  def event
    @event = Event.find(params[:id])
    
    respond_to do |format|
      format.json { render json: @event }
      format.xml { render xml: @event }
    end
  end

  # DELETE /event/destroy/1
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to :controller => 'landmarks', :action => 'index'
  end
end
