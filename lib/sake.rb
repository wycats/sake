#!/usr/bin/env ruby

require 'rubygems'
require 'rake'

require 'sake/rake_faker'
require 'sake/hacks'
require 'sake/tasks'

require 'sake/action'

class Sake
  extend Tasks

  def initialize(args = [])
    @options = {
      :args   => args,
      :target => detect_target(args),
      :source => detect_source(args)
    }
  end

  def invoke
    require "sake/actions/#{action}"
    Sake.const_get(action.classify).new(@options).invoke
  end

  def self.tasks
    sake_tasks
  end

  ##
  # Command line parsing
  def action
    Action.choose_action(@options)
  end

  def detect_target(args)
    args.detect { |arg| arg[/-|:\/\//].nil? }
  end

  def detect_source(args)
    args.detect { |arg| arg[/(\w+:\/\/)/] }
  end
end

Sake.new(ARGV).invoke if $0 == __FILE__
