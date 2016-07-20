def randstr(length=8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  size = base.size
  re = '' << base[rand(size-10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  re
end

FilePartUpload.config do
  mode :qiniu

  qiniu_bucket         ENV["qiniu_bucket"]
  qiniu_domain         ENV["qiniu_domain"]
  qiniu_base_path      ENV["qiniu_base_path"]
  qiniu_app_access_key ENV["qiniu_app_access_key"]
  qiniu_app_secret_key ENV["qiniu_app_secret_key"]
  qiniu_callback_host  ENV["qiniu_callback_host"]

  qiniu_audio_and_video_transcode(ENV["qiniu_audio_and_video_transcode"] || :enable)
  qiniu_pfop_pipeline  ENV["qiniu_pfop_pipeline"]
end

module NoteMod
  class Note
    include Mongoid::Document
    include Mongoid::Timestamps
     # title content 不能为空
    field :title,   :type => String
    field :content, :type => String
    validates :title, presence: true
    validates :content, presence: true
    # creator 不能为空
    belongs_to :creator, class_name: 'User'

    belongs_to :targetable, polymorphic: true
  end
end

QuestionMod::Question.class_eval do
  belongs_to :targetable, polymorphic: true
end
