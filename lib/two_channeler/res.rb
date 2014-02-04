require "./two_channeler/parser"
require "./two_channeler/thread"
require 'time'

module TwoChanneler
  class Response
    attr_reader :name, :email, :date, :id, :body, :anchor, :anchor_to, :anchored, :index
    attr_writer :anchored, :anchor
    def initialize(d, t, i)
      @thread = t
      @index = i + 1
      d.shift.gsub(/\s*\<\/?b\>/,'') =~ /(.+)\((.+)\)/
      @name = $1
      @pref = $2
      @email = d.shift
      @anchor_to = []
      @anchored = []
      @anchor = []
      t, @id = d.shift.split(/\ ID\:/)
      unless t =~ /Over 1000 Thread/
        @date = Time.parse(t)
      else
        @date = nil
      end
      @body = d.shift.gsub(/(^\ )|(\ $)/,'').gsub(" \<br\> ","\n")
      @body.gsub!(/\<a\ href\=\"(\w|\d|\/|\.)+\" target\=\"\_blank\"\>\&gt\;\&gt\;(\d+)\<\/a\>/) do |w|
        w =~ /\&gt\;\&gt\;(\d+)/
        @anchor_to << $1.to_i
        ">>#{$1}"
      end
    end
  end
end
