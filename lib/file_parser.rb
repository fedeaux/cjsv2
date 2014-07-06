module CJSV
  class FileParser
    def initialize(file_name)
      @coffee_indent = 0
      @cjsv_indent = 0

      @function_name = FileParser.function_name_by_file file_name

      @lines = File.open(file_name, "rb").read.split "\n"
      @current_line = 0

      sanitize_and_verify
      parse
    end

    def body
      @function_body
    end

    def name
      @function_name
    end

    def signature
      return @arguments_line.line+' ->' if @arguments_line
      '() ->'
    end

    def sanitize_and_verify()
      @spaces_per_indent = 2
      @lines = @lines.reject{|line| line =~ /^\s*$/}.map { |line|
        line.split('-#')[0].rstrip # Remove comment lines and trailing whitespace
      }.reject{|line| line =~ /^\s*$/} # Reject empty lines
    end

    def parse()
      @parsed_lines = []

      @lines.each do |line|
        parsed_line = LineParserFactory.create(line, @spaces_per_indent)

        if parsed_line.is_a? ArgsLineParser
          @arguments_line = parsed_line

        else
          @parsed_lines << parsed_line
        end
      end

      generate_function_body
    end

    def close_tags(block_level, target_indentation)
      while @unclosed_tags[block_level] and @unclosed_tags[block_level].length > 0 and @unclosed_tags[block_level].last.indentation >= target_indentation
        @function_body += cjsv_line @unclosed_tags[block_level].pop.close
      end
    end

    def add_unclosed_tag(parsed_line)
      @unclosed_tags[@spawn_blocks.length] ||= []
      @unclosed_tags[@spawn_blocks.length] << parsed_line
    end

    # def there_is_a_block_that_was_opened_in_this_indentation? indentation
    #   @spawn_blocks.length > 0 and @spawn_blocks.last.indentation >= indentation
    # end

    def close_tags_in_block_and_finish_it indentation
      #close tags
      close_tags @spawn_blocks.length, indentation

      #finish_block
      @spawn_blocks.pop
    end

    def close_blocks_and_tags_greater_than_this_indentation indentation
      while @spawn_blocks.length >= indentation
        close_tags_in_block_and_finish_it @spawn_blocks.length

        break if @spawn_blocks.length == 0
      end
    end

    def generate_function_body
      @function_body = "\n"
      @function_body += ' '*@spaces_per_indent+'  _outstream=""'+"\n"

      @unclosed_tags = {}
      @spawn_blocks = []

      @parsed_lines.each do |parsed_line|
        close_blocks_and_tags_greater_than_this_indentation parsed_line.indentation

        if parsed_line.is_a? CjsvLineParser
          @function_body += cjsv_line parsed_line.html
          add_unclosed_tag parsed_line unless parsed_line.is_self_enclosed_tag?

        elsif parsed_line.is_a? CoffeeLineParser
          @function_body += coffee_line parsed_line.line
          @spawn_blocks << parsed_line if parsed_line.span_block?
        end
      end

      close_blocks_and_tags_greater_than_this_indentation 0
    end

    def indentation
      "\n  "+' '*(@spaces_per_indent)*@spawn_blocks.length+' '*(@spaces_per_indent)
    end

    def cjsv_line(html)
      indentation+'_oustream += "'+html+'"'
    end

    def coffee_line(coffee)
      indentation+coffee
    end

    def self.function_name_by_file(file_name)
      file_name.split('/').last.gsub(/.cjsv$/, '')
    end
  end

end
