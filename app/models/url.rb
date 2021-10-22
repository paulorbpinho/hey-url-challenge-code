# frozen_string_literal: true

class Url < ApplicationRecord
  # scope :latest, -> {}
  validates :original_url, presence: true, url: true
  validates :short_url, presence: true, length: { is: 5 }, format: { with: /\A[A-Z]+\z/, message: "only uppercase letters allowed" }
  validates :short_url, uniqueness: true, on: :create
  has_many :clicks

  def self.next_short_url
    numeric_letters = [65,65,65,65,65]
    last_id = Url.maximum('id')
    last_id ||= -1
    last_id += 1
    numeric_increment_index = 4
    while( numeric_increment_index >= 0 )
      increment = last_id / ( 26 ** numeric_increment_index )
      numeric_letters[4 - numeric_increment_index] += increment
      last_id -= increment * ( 26 ** numeric_increment_index )
      numeric_increment_index -= 1
    end
    numeric_letters.map { |number| number.chr }.join('')
  end

  def as_json(options)
    { type: "url", id: self.id,
      attributes: {
        "created-at": self.created_at,
        "original-url": self.original_url,
        clicks: self.clicks_count,
        url: "http://localhost:3000/" + self.short_url
      },
      relationships: {
        clicks: {
          data: self.clicks.map { |click| { id: click.id, type: 'click' } }
        }
      }
    }
  end
end
