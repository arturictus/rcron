require "rcron/version"
module Rcron
  def self.call(command)
    puts command
    'ok'
  end
end
