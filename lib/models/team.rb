# frozen_string_literal: true

class Team < ActiveRecord::Base
  extend ActiveSupport::Concern

  def self.purge!(dt = 2.weeks.ago); end

  attr_accessor :server

  SORT_ORDERS = ['created_at', '-created_at', 'updated_at', '-updated_at'].freeze

  scope :active, -> { where(active: true) }

  validates_uniqueness_of :token, message: 'has already been used'
  validates_presence_of :token
  validates_presence_of :team_id

  def deactivate!
    update!(active: false)
  end

  def activate!(token)
    update!(active: true, token: token)
  end

  def to_s
    {
      name: name,
      domain: domain,
      id: team_id
    }.map do |k, v|
      "#{k}=#{v}" if v
    end.compact.join(', ')
  end
end
