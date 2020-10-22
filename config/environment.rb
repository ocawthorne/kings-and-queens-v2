require 'open-uri'
require 'nokogiri'
require 'io/console'
require 'colorize'

require_relative '../lib/cli.rb'
require_relative '../lib/dynasty.rb'
require_relative '../lib/monarch.rb'
require_relative '../lib/scraper.rb'

CLI.new.run