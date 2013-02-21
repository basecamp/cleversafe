#!/usr/bin/env ruby
  require 'rubygems'
  require 'rest-client'
  require 'json'

  $:.unshift(File.dirname(__FILE__))
  require 'cleversafe/vault'
  require 'cleversafe/object'
  require 'cleversafe/connection'