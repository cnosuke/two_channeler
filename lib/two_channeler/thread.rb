require "./two_channeler/parser"
require "./two_channeler/res"

module TwoChanneler
	class Thread
		attr_reader :subject, :responses, :dat_path, :board_path
		def initialize(dat_path: nil, subject: nil, count: nil, board_path: nil, fetch: false)
			@dat_path = dat_path
			@subject = subject
			@count = count
			@board_path = "#{board_path}dat/" if board_path
			@responses = []
			fetch_thread if fetch
		end
		def fetch_thread
			begin
				d = TwoChanneler::Parser.parse(@board_path.to_s + @dat_path)
				@subject = d.first.fetch(-1)
				@responses = d.map.with_index do |res, idx|
					Response.new(res, self, idx)
				end
				@responses.map do |r|
					r.anchor = @responses.select{|i| r.anchor_to.include? i.index }
					r.anchor_to.each do |anchor|
						@responses[anchor - 1].anchored << r if @responses[anchor - 1]
					end
				end
				@fetch = true
				self
			rescue => e
				p e
			end
		end
		def inspect
			return <<EOB
#<TwoChanneler::Thread
  @subject=#{@subject.inspect},
  @responses.size=#{@responses.size},
  @count=#{@count.inspect},
  @dat_path=#{@dat_path.inspect},
  @board_path=#{@board_path.inspect}
 >
EOB
		end
	end
end
