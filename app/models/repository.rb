class Repository < ActiveRecord::Base
  has_attached_file :uploaded,
                    :url => "/assets/uploads/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/uploads/:id/:style/:basename.:extension", #,
                    :styles =>{ :thumbnail => "50x60"}
                    #:styles => { :original => "250x300>", :thumbnail => "50x60" } #default size of uploaded image
  validates_attachment_size :uploaded, :less_than => 50.megabytes
  validates_attachment_content_type :uploaded, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  
  def save_uploads(repoid, filename)
    repo=Repository.find(repoid)
    # NOTE - path is local PC
    afile=File.open("/home/shimah/Desktop/[16] Digital Library - MarkasPmrthnArmada@Lumut/Sample Digital Documents/prev samples/batch 2-kd mahawangsa/#{filename}")
    repo.uploaded=afile
    repo.save!
  end
  
  def render_staff
    Repository::STAFF_LIST.find_all{|disp, value|value==1}.map{|disp, value|disp}.first
  end
  
  STAFF_LIST=[["Abu", 1], ["Aminah", 2]]
  
end
