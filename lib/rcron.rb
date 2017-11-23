require "rcron/version"
require 'erlectricity'

receive do |f|
  f.when([:echo, String]) do |text|
    f.send!([:result, "You said: #{text}"])
    f.receive_loop
  end
end

module Rcron
  # Your code goes here...
end
