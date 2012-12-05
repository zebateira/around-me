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
end
