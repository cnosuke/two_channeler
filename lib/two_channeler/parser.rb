require 'open-uri'

module TwoChanneler
  class Parser
    def self.parse(file)
      doc = read_dat(file)
      doc.split("\n").map{|e| e.split("<>")}
    end

    def self.read_dat(file)
      open(file, 'r:Shift_JIS').read
      .encode("UTF-8", :invalid => :replace, :undef => :replace)
    end
  end
end
