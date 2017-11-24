require "rcron/version"
require 'json'
module Rcron
  def self.call(data)
    hash = JSON.parse(data)
    JSON.generate(hash)
  end
end
