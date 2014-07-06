#!/usr/bin/env ruby

require 'rubygems'
require 'listen'
require 'fileutils'
require 'optparse'
require 'colorize'

require_relative 'lib/file_parser.rb'

require_relative 'lib/coffee_line_parser.rb'
require_relative 'lib/cjsv_line_parser.rb'
require_relative 'lib/args_line_parser.rb'
require_relative 'lib/factory_line_parser.rb'
require_relative 'lib/line_renderer.rb'

module CJSV
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

    def watch?
      @config['watch_directories']
    end

    def parse_directory(path, namespace)
      Dir.foreach(path) do |item|
        next if item == '.' or item == '..'

        if File.directory? path+item then
          namespace[item] = {} unless namespace[item]
          self.parse_directory path+item+'/', namespace[item]

        elsif item.split('.').last == 'cjsv' then
          function = self.parse_file path+item
          namespace[function.name] = function if function
        end
      end
    end

    def parse_file(file_name)
      FileParser.new file_name if File.exist? file_name
    end

    def file_changed_or_added(file_name)
      function = FileParser.new file_name

      namespace = get_namespace_directly file_name
      namespace[function.name] = function

      generate_object
    end

    def file_removed(file_name)

      file_name = file_name
        .gsub(@config['input_dir'], '')
        .gsub('.cjsv', '')

      parts = file_name.split '/'

      if parts.length == 1
        @namespace.delete file_name

      else
        namespace = @namespace
        parts[0..-2].each { |part| namespace = namespace[part] }
        namespace.delete parts.last
      end

      generate_object
    end

    def get_namespace_directly(file_name)
      file_name = file_name
        .gsub(@config['input_dir'], '')
        .gsub('.cjsv', '')

      parts = file_name.split '/'

      return @namespace if parts.length == 1

      namespace = @namespace

      parts[0..-2].each { |part|
        unless namespace[part]
          namespace[part] = {}
        end

        namespace = namespace[part]
      }

      namespace
    end

    def parse()
      @namespace = {}
      self.parse_directory @config['input_dir'], @namespace
      generate_object

      # # # #Add helper functions
      # # # self.output_line self.adjust_indentation File.open(@config['helpers_filename']).read

      # Make optmizations
      # self.optmize

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
        @object += '  '*level+name+': '+element.signature
        @object += element.body.split("\n").map{|line| '  '*(level - 1)+line }.join("\n")+"\n"
      end
    end

    def generate_object
      @object = @config['object_name']+' = '

      @namespace.each_pair do |name, element|
        add_to_object name, element
      end

      File.open(@config['output_dir']+@config['output_filename'], 'w') { |f| f.write @object }
    end
  end
end

cjsv = CJSV::CJSV.new
cjsv.parse

def relative_path file_name
  file_name.gsub Dir.pwd+'/', ''
end

if cjsv.watch? then
  begin
    listener = Listen.to('.', :only => /\.cjsv$/) do |modified, added, removed|
      notifier = []

      if modified.length > 0
        file = relative_path modified.first
        notifier << Time.now.strftime("%H:%M")+' - [modified] '+file
        cjsv.file_changed_or_added file
        puts notifier.join('\n').light_green

      elsif added.length > 0
        file = relative_path added.first
        notifier << Time.now.strftime("%H:%M")+' - [created] '+file
        cjsv.file_changed_or_added file
        puts notifier.join('\n').light_green

      elsif removed.length > 0
        file = relative_path removed.first
        notifier << Time.now.strftime("%H:%M")+' - [removed] '+file
        cjsv.file_removed file
        puts notifier.join("\n").red
      end

    end

    listener.start
    sleep

  rescue SystemExit, Interrupt
    puts 'Abort'
  end
end
