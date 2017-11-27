require "rcron/version"
require 'json'
module Rcron
  def self.call(data)
    hash = JSON.parse(data)
    pre.each do |m|
      inst = m.new(data)
      break unless inst.call
    end
    JSON.generate(hash)
  end

  def self.config(&block)
    yield(self)
  end

  def self.prepend_middleware(m)
    @prepend ||= []
    @prepend << m
  end

  def self.pre
    @prepend ||= []
  end
end
