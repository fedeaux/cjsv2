module CJSV
  class ArgsLineParser
    def initialize(line, spaces_per_indent, cjsv_instance)
      @line = line.strip
    end

    def line
      @line
    end
  end
end
