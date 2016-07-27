class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name, type: String

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  validates :name, presence: true
  validates :name, length: {in: 2..20}, :if => Proc.new {|user|
    user.name.present?
  }

  def id
    attributes["_id"].to_s
  end

  def info
    {
      :id    => self.id,
      :name  => self.name,
      :login => self.login,
      :email => self.email,
      :avatar => self.avatar.url
    }
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if email_or_phone_number = conditions.delete(:email).downcase
      where(conditions).where(
        '$or' => [
          {email: email_or_phone_number},
          {phone_number: email_or_phone_number}
        ]
      ).first
    else
      where(conditions).first
    end
  end

  # 角色
  extend Enumerize
  ROLES = %w[teller supervisor admin]
  enumerize :role, in: ROLES, default: :teller, scope: true
  field :phone_number, type: String
  validates :phone_number, uniqueness: true, if: :teller?
  validates :phone_number, presence: true, if: :teller?
  belongs_to :post, class_name: 'EnterprisePositionLevel::Post'

  ROLES.each do |r|
    define_method "#{r}?" do
      role == r
    end
  end

  def self.roles
    ROLES
  end

  # 柜员 user 已经学习了负责业务类别下所有课件的百分比
  def read_percent
    return 0 if !self.role.teller?
    return 0 if self.post.blank?

    post_business_category_ids = self.post.business_category_ids.map{|bid|bid.to_s}

    ware_ids = KcCourses::Ware
      .where(:business_category_ids.in => post_business_category_ids)
      .only(:id).map{|w|w.id.to_s}

    read_percent_in_wares(ware_ids)
  end

  def read_percent_in_wares(ware_ids)
    reads = ware_readings.where(:ware_id.in => ware_ids)
    return 0 if reads.blank?
    reads.sum(:read_percent) / ware_ids.count
  end
end
