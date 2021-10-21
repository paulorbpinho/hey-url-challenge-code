# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url
  validates :platform, presence: true
  validates :browser, presence: true
  validates :url, presence: true

  def as_json(options)
    { type: "click", id: self.id, 
      attributes: { 
        "created-at": self.created_at, 
        platform: self.platform, 
        browser: self.browser
      }
    } 
  end
end
