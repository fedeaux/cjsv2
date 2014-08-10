# -*- coding: utf-8 -*-
module CJSV
  class FileParser
    def initialize(file_name, cjsv_instance)
      @coffee_indent = 0
      @cjsv_indent = 0
      @cjsv_instance = cjsv_instance

      @function_name = FileParser.function_name_by_file file_name

      @lines = File.open(file_name, "rb").read.split "\n"
      @current_line = 0

      sanitize_and_verify
      parse
    end

    def body
      @cjsv_lines_renderer.function_body
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
        parsed_line = LineParserFactory.create(line, @spaces_per_indent, @cjsv_instance)

        if parsed_line.is_a? ArgsLineParser
          @arguments_line = parsed_line

        else
          @parsed_lines << parsed_line
        end
      end

      generate_function_body
    end

    def add_unclosed_tag(parsed_line)
      @unclosed_tags[spawn_blocks] ||= []
      @unclosed_tags[spawn_blocks] << parsed_line
    end

    def close_tags_in_block_and_finish_it indentation
      #close tags
      close_tags spawn_blocks, indentation

      #finish_block
      @spawn_blocks.pop
    end

    def close_blocks_that_were_opened_in_a_higher_or_equal_indentation indentation
      while spawn_blocks > 0 and @spawn_blocks.last.indentation >= indentation
        close_tags_in_block_and_finish_it spawn_blocks
      end
    end

    def close_tags(block_level, target_indentation)
      while @unclosed_tags[block_level] and @unclosed_tags[block_level].length > 0 and @unclosed_tags[block_level].last.indentation >= target_indentation
        @cjsv_lines_renderer.add indentation, @unclosed_tags[block_level].pop, true
      end
    end

    def generate_function_body
      @cjsv_lines_renderer = LineRenderer.new @spaces_per_indent, self

      @unclosed_tags = {}
      @spawn_blocks = []

      @parsed_lines.each do |parsed_line|
        close_blocks_that_were_opened_in_a_higher_or_equal_indentation parsed_line.indentation
        close_tags spawn_blocks, parsed_line.indentation

        @cjsv_lines_renderer.add indentation, parsed_line

        if parsed_line.is_a? CjsvLineParser
          add_unclosed_tag parsed_line unless parsed_line.is_self_enclosed_tag?

        elsif parsed_line.is_a? CoffeeLineParser
          @spawn_blocks << parsed_line if parsed_line.span_block?
        end
      end

      close_blocks_that_were_opened_in_a_higher_or_equal_indentation 0
      close_tags 0, 0
    end

    def indentation
      "\n  "+' '*(@spaces_per_indent)*spawn_blocks+' '*(@spaces_per_indent)
    end

    def spawn_blocks
      @spawn_blocks.length
    end

    def self.function_name_by_file(file_name)
      file_name.split('/').last.gsub(/.cjsv$/, '')
    end
  end

end
