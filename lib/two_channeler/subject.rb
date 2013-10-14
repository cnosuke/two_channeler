require "./two_channeler/parser"
require "./two_channeler/res"
require "./two_channeler/thread"

module TwoChanneler
  class Subject
    attr_reader :threads, :d
    def initialize(board_path)
      @board_path = board_path
      @subject_path = board_path + 'subject.txt'
      dd = TwoChanneler::Parser.parse(@subject_path)
      @threads = dd.map.with_index do |th,i|
        Thread.new( dat_path: th[0],
          subject: th[1].gsub(/\s\(\d+\)$/,''),
          count: th[1].scan(/\(\d+\)$/).first.gsub(/\(|\)/,'').to_i,
          board_path: board_path,
          fetch: false
          )
      end
    end
  end
end

