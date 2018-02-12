class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :download, :update, :destroy]

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all.order(created_at: :desc)
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(repository_params)

    respond_to do |format|
      if @repository.save
        #format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        #format.json { render :show, status: :created, location: @repository }
        format.js { render :create }
      else
        format.html { render :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
  def update
    #raise params.inspect
#     respond_to do |format|
#       if @repository.update(repository_params)
#          #format.html { redirect_to repository_path(@repository), notice: 'Repository was successfully updated.' }
#          format.html { redirect_to repositories_path, notice: 'Repository was successfully updated.' }
#          format.json { render :show, status: :ok, location: @repository }
#          format.js {render :update}
#       else
#          format.html { render :edit }
#          format.json { render json: @repository.errors, status: :unprocessable_entity }
#       end
#     end
    
    #UploadWorker.perform_async(@repository.id)
    #UploadWorker.perform_async(@repository.id, repository_params)
    #render text: "Request to put upload into queue" # "Upload done in background"
    
    # working - last updated 10th July 2017
    UploadWorker.perform_async(@repository.id, params[:repository][:title], params[:repository][:staff_id], params[:repository][:data], params[:repository][:uploaded], params[:repository][:uploaded].original_filename, params[:repository][:uploaded].tempfile, params[:repository][:uploaded].content_type, params[:repository][:uploaded].headers, params[:repository][:uploaded].tempfile.path )
    respond_to do |format|
      format.html { redirect_to repositories_path, notice: 'Uploading in progress....' }
    end
    
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url, notice: 'Repository was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  #not working yet - last updated 10th July 2017
  def download
    #@repository=Repository.find(params[:id])
    #url=/assets/uploads/1/original/BK-KKM-01-01_BORANG_PENILAIAN_KURSUS.pdf?1474870599
    #send_file("#{::Rails.root.to_s}/public#{@repository.uploaded.url.split("?").first}")
    @filename="#{::Rails.root.to_s}/public#{@repository.uploaded.url.split("?").first}"
    #send_file(@filename ,  :type => 'application/pdf/docx/html/htm/doc', :disposition => 'attachment')
    send_file(@filename ,:type => 'application/pdf', :disposition => 'attachment')
  end
  
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
  
  def events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])
    
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end
  
  def new_event
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    today = Date.today

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
      summary: params[:summary], #'New event!'
    })

    service.insert_event(params[:calendar_id], event)

    redirect_to events_url(calendar_id: params[:calendar_id])
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
  
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:title, :staff_id, :data, :uploaded, :uploaded_file_name, :uploaded_content_type, :uploaded_file_size)
    end
end
