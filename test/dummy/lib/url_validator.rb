# frozen_string_literal: true
require 'set'
require 'uri'

class UrlValidator < ActiveModel::Validator
  VALID_SCHEMES = Set.new(%w(http https ftp))
  def validate_each(record, attribute, value)
    unless value.present? && url?(value)
      record.errors[attribute] << (options[:message] || "must be one of [#{VALID_SCHEMES.map(&:upcase).join(', ')}]")
    end
  end

  def url?(string)
    uri = URI(string)
    return uri.scheme.in?(VALID_SCHEMES)
  rescue URI::InvalidURIError
    return false
  end
  private :url?
end
