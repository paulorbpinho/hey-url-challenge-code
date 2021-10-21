# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

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
