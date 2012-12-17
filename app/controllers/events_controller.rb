require 'json'

class EventsController < ApplicationController

  # GET /events/1
  # GET /events/1.json
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

		if params.include?('update')
			puts 'updating event ' + @event.fb_id + '...'
			@event.update_attributes(FbConnection.new.fetch_event(@event.fb_id))
			puts 'event ' + @event.fb_id + ' updated.'
		end
    
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
