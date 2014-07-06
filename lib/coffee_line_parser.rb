module CJSV
  class CoffeeLineParser
    def initialize(line, spaces_per_indent)
      @line = line
      @spaces_per_indent = spaces_per_indent
      @debug = true
      parse
    end

    def indentation
      @indentation
    end

    def line
      @line
    end

    def span_block?
      (@line =~ /if|while|for|else|unless/i).is_a? Numeric
    end

    def preprocess_line
      @line = @line.gsub(LineParserFactory.coffee_line_regex, '').strip
    end

    def parse
      preprocess_line
    end
  end
end
