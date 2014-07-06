module CJSV
  class LineRenderer
    def initialize(spaces_per_indent, file_parser)

      @spaces_per_indent = spaces_per_indent
      @file_parser = file_parser

      @function_body = "\n"
      @function_body += ' '*@spaces_per_indent+'  _outstream=""'+"\n"
    end

    def add(indentation, parsed_line, close = false)
      if parsed_line.is_a? CjsvLineParser
        unless close
          @function_body += cjsv_line parsed_line.html
        else
          @function_body += cjsv_line parsed_line.close
        end

      elsif parsed_line.is_a? CoffeeLineParser
        @function_body += coffee_line parsed_line.line

      end
    end

    def cjsv_line(html)
      @file_parser.indentation+'_oustream += "'+html+'"'
    end

    def coffee_line(coffee)
      @file_parser.indentation+coffee
    end

    def function_body
      @function_body
    end
  end
end
