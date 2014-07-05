#!/usr/bin/env ruby

require 'rubygems'
require 'listen'
require 'fileutils'
require 'optparse'

require './lib/file_parser.rb'
require './lib/line_parser.rb'

class CJSV
  def initialize()

    @config = {
      'debug' => false,
      'input_dir' => 'cjsv/',
      'output_dir' => 'coffee/',
      'output_filename' => 'cjsv.coffee',
      'helpers_filename' => File.dirname(__FILE__)+'/helpers.coffee',
      'output_generated_file' => false,
      'watch_directories' => true,
      'attributes_shorcuts' => {},
      'tags_shorcuts' => {},
      'optmizations' => ['delete_comments', 'shrink_blocks'],
      'object_name' => '@CJSV'
    }

    OptionParser.new do |opts|
      opts.on("--input_dir [INPUT_DIR]", :text, "Root folder to watch") do |v|
        @config['input_dir'] = v
      end

      opts.on("--output_dir [OUTPUT_DIR]", :text, "Root folder to output") do |v|
        @config['output_dir'] = v
      end
    end.parse!

    @config['output_path'] = @config['output_dir']+@config['output_filename']

    @no_conflict = {
      '\+' => '__JSV_PLUS_SIGN_PLACEHOLDER_4712891294__'
    }

    if File.exist?('.jsv-config.rb') then
      require './.jsv-config.rb'
      puts "using .jsv-config"
      @config.merge!(preferences)
    end

    @self_enclosed_tags = ['img', 'br', 'hr', 'input']
  end

  def parse_directory(path, namespace)
    Dir.foreach(path) do |item|
      next if item == '.' or item == '..'

      if File.directory? path+item and false then
        namespace[item] = {} unless namespace[item]
        self.parse_directory path+item+'/', namespace[item]

      elsif item.split('.').last == 'cjsv' and item == 'lines.cjsv' then
        function = self.parse_file path+item
        namespace[function.name] = function.body
      end
    end
  end

  def parse_file(file_name)
    CJSVFileParser.new(file_name)
  end

  def parse()
    ### self.output_line "@"+@config['object_name']+" = \n"
    @path = @config['input_dir']
    @namespace = {}

    self.parse_directory @path, @namespace

    generate_object

    # # # #Add helper functions
    # # # self.output_line self.adjust_indentation File.open(@config['helpers_filename']).read

    # # # #Make optmizations
    # # # self.optmize

    # # # self.write_output
  end

  def add_to_object(name, element, level = 1)
    @object += "\n"

    if element.is_a? Hash
      @object += '  '*level+name+':'

      element.each_pair do |_name, _element|
        add_to_object _name, _element, level + 1
      end

    else
      @object += '  '*level+name
      @object += element.split("\n").map{|line| '  '*(level - 1)+line }.join("\n")+"\n"
    end
  end

  def generate_object
    @object = @config['object_name']+':'

    @namespace.each_pair do |name, element|
      add_to_object name, element
    end

    File.open('out.coffee', 'w') { |f| f.write @object }
  end
end

cjsv = CJSV.new
cjsv.parse

# if cjsv.watch? then
#   begin
#     listener = Listen.to('.', :only => /\.cjsv$/) do |modified, added, removed|
#       puts Time.now.strftime("%H:%M:%S")

#       trigger = 'changed '+modified.join('/')+'/'+added.join('/')+'/'+removed.join('/')

#       cjsv = JSV.new
#       cjsv.parse
#     end

#     listener.start
#     sleep

#   rescue SystemExit, Interrupt
#     puts 'Abort'
#   end
# end
