module CJSV
  class LineParserFactory
    def self.create(line, spaces_per_indent)
      @line = line
      @spaces_per_indent = spaces_per_indent

      identify_line

      return @type.new line, spaces_per_indent
    end

    def self.identify_line
      @type = 'CJSV_ARGS_LINE'

      if (@line =~ args_line_regex) != nil
        @type = ArgsLineParser

      elsif (@line =~ coffee_line_regex) != nil
        @type = CoffeeLineParser

      else
        @type = CjsvLineParser

      end
    end

    def self.coffee_line_regex
      /^\s*-/
    end

    def self.args_line_regex
      /^\s*\(/
    end
  end
end
