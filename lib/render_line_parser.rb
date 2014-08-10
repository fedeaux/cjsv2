module CJSV
  class RenderLineParser
    def initialize(line, spaces_per_indent, cjsv_instance)
      @line = line
      @spaces_per_indent = spaces_per_indent
      @debug = true
      @cjsv_instance = cjsv_instance

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
      @indentation = @line.scan(/^\s*/)[0].size/@spaces_per_indent
      @line = @line.gsub(LineParserFactory.render_line_regex, '').strip
    end

    def parse
      preprocess_line
    end
  end
end
