class StaticPagesController < ApplicationController
  def home
  end
  
  ###moved from repositories -- from events  start
  
  # NOTE- google calendar - tried 12Feb2018 - successful - reference : https://readysteadycode.com/howto-integrate-google-calendar-with-rails
  # Gmail account in use : nurhashimah77@gmail.com
  # step (1) starting page from http://127.0.1.1:4000/redirect --> if not yet authorized, google calendar allow page will be displayed, requires prompt response(to allow)
  # step (2) once authorized, page will be directed to calendars page (containing list of shared calendars w nurhashimah77@gmail.com) -- (http://127.0.0.1:4000/calendars?locale=en)
  # step (3) browse for --> http://127.0.0.1:4000/events/nurhashimah77@gmail.com?locale=en - NEW event button & ALL events for nurhashimah77@gmail calendar will be displayed
  
  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri.to_s
  end
  
  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!
    session[:authorization] = response
    redirect_to calendars_url
  end
  
  def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
    
    rescue Google::Apis::AuthorizationError
      response = client.refresh!
      session[:authorization] = session[:authorization].merge(response)
      retry 
  end
  
  def dashboard #listing#events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])
    
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end
  
  def new_event_dash#new_event
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    #today = Date.today
    dt=params[:start]
    today=Date.new(dt[6,4].to_i, dt[3,2].to_i, dt[0,2].to_i)
    
    #today=DateTime.new(dt[6,4].to_i, dt[3,2].to_i, dt[0,2].to_i, dt[14,2].to_i, dt[11,2].to_i, 0, "+8")  #DateTime.new(2018,02,13,17,56,20,"+8")

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
      summary: params[:summary], #'New event!'
    })

    service.insert_event(params[:calendar_id], event)
    
    #add same event to Event table in local DB
    a=Event.create(eventname: params[:summary], location: "dewan a", start_at: params[:start], end_at: Date.today.tomorrow)

    #redirect_to events_url(calendar_id: params[:calendar_id])
    redirect_to "/dashboard/#{params[:calendar_id]}"
  end
  
  private
  
    # NOTE- google calendar - tried 12Feb2018 - successful
    def client_options
      {
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        redirect_uri: callback_url
      }
    end
    
  ###moved from repositories - from events - end
  
end
