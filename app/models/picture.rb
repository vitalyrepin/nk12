class Picture < ActiveRecord::Base
  belongs_to :protocol
  mount_uploader :picture, PictureUploader
  
  def to_jq_upload
  {
    "name" => read_attribute(:avatar),
    "size" => avatar.size,
    "url" => avatar.url,
    "thumbnail_url" => avatar.thumb.url,
    "delete_url" => picture_path(:id => id),
    "delete_type" => "DELETE" 
   }
  end
end
