module CJSV
  class LineParserFactory
    def self.create(line, spaces_per_indent)
      @line = line
      @spaces_per_indent = spaces_per_indent

      identify_line

      if @type == CoffeeLineParser
        return CoffeeLineParser.new line, spaces_per_indent

      elsif @type == CjsvLineParser
        return CjsvLineParser.new line, spaces_per_indent
      end
    end

    def self.identify_line
      @type = 'CJSV_ARGS_LINE'

      if (@line =~ coffee_line_regex) != nil
        @type = CoffeeLineParser

      else
        @type = CjsvLineParser

      end
    end

    def self.coffee_line_regex
      /^\s*-/
    end
  end
end
