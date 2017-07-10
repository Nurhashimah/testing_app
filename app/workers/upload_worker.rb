class UploadWorker
  include Sidekiq::Worker
  #sidekiq_options retry :false
  #sidekiq_options queue: "upload" #Unremark this to add job to queue & run in 3rd konsole ($ bundle exec sidekiq -q upload, 5 default) to run queued job

  def perform(repoid, tajuk, staf, info, upfile, filename, tempp_file, typpe, headerss, tempp_path)
 # def perform(repoid)
    # Do something
    repository=Repository.find(repoid)
    puts "Sidekiq UPLOAD worker running job (title asal : #{repository.title} #{upfile} - #{typpe}  __  #{headerss} ::::: #{tempp_path}/#{tempp_file})"
    repository.update_attributes(title: 'test punye')
    repository.save_uploads(repoid, filename)    

    #repository.update_attributes(title: tajuk, staff_id: staf, data: info) 
  end
end
