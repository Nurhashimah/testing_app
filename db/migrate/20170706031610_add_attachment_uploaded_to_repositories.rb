class AddAttachmentUploadedToRepositories < ActiveRecord::Migration
  def self.up
    change_table :repositories do |t|
      t.attachment :uploaded
    end
  end

  def self.down
    remove_attachment :repositories, :uploaded
  end
end
