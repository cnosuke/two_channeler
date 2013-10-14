require "./two_channeler/parser"
require "./two_channeler/thread"
require 'time'

module TwoChanneler
  class Res
    attr_reader :name, :email, :date, :id, :body, :res
    def initialize(d, t)
      @thread = t
      d.shift.gsub(/\s*\<\/?b\>/,'') =~ /(.+)\((.+)\)/
      @name = $1
      @pref = $2
      @email = d.shift
      @res = []
      t, @id = d.shift.split(/\ ID\:/)
      unless t =~ /Over 1000 Thread/
        @date = Time.parse(t)
      else
        @date = nil
      end
      @body = d.shift.gsub(/(^\ )|(\ $)/,'').gsub(" \<br\> ","\n")
      @body.gsub!(/\<a\ href\=\"(\w|\d|\/|\.)+\" target\=\"\_blank\"\>\&gt\;\&gt\;(\d+)\<\/a\>/) do |w|
        w =~ /\&gt\;\&gt\;(\d+)/
        @res << $1.to_i
        ">>#{$1}"
      end
    end
  end
end
