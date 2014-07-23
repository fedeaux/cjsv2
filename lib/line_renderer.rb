module CJSV
  class LineRenderer
    def initialize(spaces_per_indent, file_parser)

      @spaces_per_indent = spaces_per_indent
      @file_parser = file_parser

      @function_body = "\n"
      @function_body += ' '*@spaces_per_indent+'  _outstream=""'+"\n"
      @current_indentation = ''
      @cjsv_lines_queue = []

      @render_strategy = 'condensed'
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
      if not @render_strategy
        render_simple
      elsif @render_strategy == 'condensed'
        render_condensed
      end

    end

    def render_simple
      if @cjsv_lines_queue.length > 0
        @cjsv_lines_queue.each { |queue_element|
          @function_body += cjsv_single_line queue_element_html queue_element
        }
      end
      @cjsv_lines_queue = []
    end

    def render_pretty
      if @cjsv_lines_queue.length == 1 or @cjsv_lines_queue.length == 2
        render_condensed
      elsif @cjsv_lines_queue.length > 2
        @function_body += cjsv_first_line queue_element_html @cjsv_lines_queue.first
        @function_body += cjsv_inner_line @cjsv_lines_queue[1..-2].map { |e| queue_element_html(e) }.join ''
        @function_body += cjsv_last_line queue_element_html @cjsv_lines_queue.last
      end
    end

    def render_condensed
      if @cjsv_lines_queue.length > 0
        @function_body += cjsv_single_line @cjsv_lines_queue.map { |e| queue_element_html(e).strip }.join ''
      end

      @cjsv_lines_queue = []
    end

    def cjsv_single_line(html)
      @current_indentation+'_outstream += "'+html+'"'
    end

    def cjsv_first_line(html)
      @current_indentation+'_outstream += "'+html+"\n"
    end

    def cjsv_inner_line(html)
      @current_indentation+'              '+html+"\n"
    end

    def cjsv_last_line(html)
      @current_indentation+'              '+html+"\"\n"
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
