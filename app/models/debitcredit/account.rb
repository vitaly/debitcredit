module Debitcredit
  class Account < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    has_many :items, dependent: :destroy

    validates :name, :balance, presence: true

    def self.[](name)
      find_by!(name: name)
    end
  end
end
