module CJSV
  class LineRenderer
    def initialize(spaces_per_indent, file_parser)

      @spaces_per_indent = spaces_per_indent
      @file_parser = file_parser

      @function_body = "\n"
      @function_body += ' '*@spaces_per_indent+'  _outstream=""'+"\n"
      @current_indentation = ''
      @cjsv_lines_queue = []
    end

    def add(indentation, parsed_line, close = false)
      if indentation != @current_indentation or parsed_line.is_a? CoffeeLineParser
        render
        @current_indentation = indentation
      end

      if parsed_line.is_a? CjsvLineParser
        @cjsv_lines_queue << { :parsed_line => parsed_line, :close => close }

      elsif parsed_line.is_a? CoffeeLineParser
        @function_body += coffee_line parsed_line.line
      end
    end

    def queue_element_html(queue_element)
      unless queue_element[:close]
        html = queue_element[:parsed_line].html
      else
        html = queue_element[:parsed_line].close
      end
    end

    def render
      render_condensed
    end

    def render_condensed
      if @cjsv_lines_queue.length > 0
        @function_body += cjsv_single_line @cjsv_lines_queue.map { |e| queue_element_html(e).strip }.join ''
      end

      @cjsv_lines_queue = []
    end

    def cjsv_single_line(html)
      @current_indentation+'_oustream += "'+html+'"'
    end

    def coffee_line(coffee)
      @current_indentation+coffee
    end

    def function_body
      render
      @function_body
    end
  end
end
