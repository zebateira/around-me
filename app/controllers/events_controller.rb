require 'json'

class EventsController < ApplicationController

  # GET /events/1
  # GET /events/1.json
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

		if params.include?('update')
			puts 'Forcing event update...'
				update @event
		else
			update_thread = Thread.new do
				sleep(1)

				if FbConnection.new.is_event_outdated @event
					update @event
				else
					puts 'Event ' + @event.fb_id + ' up to date.'
				end
			end
		end
    
    respond_to do |format|
      format.json { render json: @event }
      format.xml { render xml: @event }
    end
  end


	def update(event)
		fb_connection =	FbConnection.new
	
		puts 'Updating outdated event ' + event.fb_id + '...'
		event.update_attributes(fb_connection.fetch_event(event.fb_id))
		puts 'Event ' + event.fb_id + ' updated.'
	end

  # DELETE /event/destroy/1
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to :controller => 'landmarks', :action => 'index', notice: 'Event successfully destroyed.'
  end
end
