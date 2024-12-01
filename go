#! /usr/bin/env ruby

day, test = ARGV
raise "which day?" unless day
test ||= "fake"

require_relative "tools"
require_relative "./#{day}/main"

Solutions.send(test.to_sym)
