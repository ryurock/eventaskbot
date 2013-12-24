#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

path = File.expand_path(__dir__ + "/../lib")
$LOAD_PATH << path

require 'eventaskbot'
require 'eventaskbot/command'
command = Eventaskbot::Command.new
command.merge
