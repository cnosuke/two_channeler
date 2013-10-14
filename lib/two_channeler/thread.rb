require "two_channeler/parser"
require "two_channeler/res"

module TwoChanneler
	class Thread
		attr_reader :title, :res, :dat_path
		def initialize(dat_path: nil, subject: nil, count: nil, board_path: nil, fetch: false)
			@dat_path = dat_path
			@subject = subject
			@count = count
			@board_path = board_path
			@res = []
			fetch_thread if fetch
		end
		def fetch_thread
			begin
				d = TwoChanneler::Parser.parse(@board_path + 'dat/' + @dat_path)
				@subject = d.first.fetch(-1)
				@res = d.map do |res|
					Res.new(res, self)
				end
				@res.map do |r|
					r.res.map! do |e|
						{ e => @res[e - 1] }
					end
				end
			rescue => e
				p e
			end
		end
	end
end
