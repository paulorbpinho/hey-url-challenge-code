# frozen_string_literal: true

class Url < ApplicationRecord
  # scope :latest, -> {}
  def self.next_short_url
    numeric_letters = [65,65,65,65,65]
    increment_letters = []
    last_id = 25
    last_id ||= self.maximum 'id'
    numeric_increment_index = 4
    while( numeric_increment_index >= 0 )
      increment = last_id / (26 ** numeric_increment_index)
      increment_letters.push increment
      last_id -= increment * (26 ** numeric_increment_index)
      numeric_increment_index -= 1
    end
    numeric_increment_index = 0
    increment_letters.each do |increment|
      numeric_letters[numeric_increment_index] += increment
      numeric_increment_index += 1
    end
    numeric_letters.map { |number| number.chr }.join('')
  end
end
