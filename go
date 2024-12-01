#! /usr/bin/env ruby

DAY, test = ARGV
raise "which day?" unless DAY
TEST = test || "fake"

require_relative "tools"
require_relative "./#{DAY}/main"

Solutions.send(TEST.to_sym)
