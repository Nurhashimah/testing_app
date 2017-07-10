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
    #url=/assets/uploads/1/original/BK-KKM-01-01_BORANG_PENILAIAN_KURSUS.pdf?1474870599
    send_file("#{::Rails.root.to_s}/public#{@repository.uploaded.url.split("?").first}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:title, :staff_id, :data, :uploaded, :uploaded_file_name, :uploaded_content_type, :uploaded_file_size)
    end
end
