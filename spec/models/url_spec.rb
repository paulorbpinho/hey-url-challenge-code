# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates original URL is a valid URL' do
      url = Url.new(short_url: Url.next_short_url, original_url: 'http://www.google.com')
      expect(url).to be_valid
    end

    it 'validates original URL is a invalid URL' do
      url = Url.new(short_url: Url.next_short_url, original_url: 'a')
      expect(url).to be_invalid
    end

    it 'validates short URL is present' do
      url = Url.new(original_url: 'http://www.google.com')
      expect(url).to be_invalid
    end

    it 'validates short URL has 5 characters' do
      url = Url.new(short_url: 'a', original_url: 'http://www.google.com')
      expect(url).to be_invalid
    end

    it 'validates short URL has 5 uppercase characters' do
      url = Url.new(short_url: 'aaaaa', original_url: 'http://www.google.com')
      expect(url).to be_invalid
    end

    it 'validates short URL don\'t have special characters' do
      url = Url.new(short_url: "aaa@a", original_url: 'http://www.google.com')
      expect(url).to be_invalid
    end

    it 'validates short URL don\'t have whitespaces' do
      url = Url.new(short_url: "aaaa ", original_url: 'http://www.google.com')
      expect(url).to be_invalid
    end

    it 'validates short URL is unique' do
      Url.new(short_url: 'AAAAA', original_url: 'http://www.google.com').save
      url = Url.new(short_url: 'AAAAA', original_url: 'http://www.google.com')
      expect(url).to be_invalid
    end
  end
end
