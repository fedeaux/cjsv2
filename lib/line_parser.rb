class CJSVLineParser
  def initialize(line, spaces_per_indent)
    @line = line
    @spaces_per_indent = spaces_per_indent

    @state = ['none']
    @tokens = {
      'tag' => 'div',
      'id' => '',
      'classes' => [],
      'attr' => {},
      'text' => ''
    }

    @self_enclosed_tags = ['img', 'br', 'hr', 'input']
    @debug = true
    parse
  end

  def html(include_indentation = true)
    if include_indentation
      return ' ' * @spaces_per_indent * @indentation + @html
    else
      @html
    end
  end

  def close(include_indentation = true)
    if include_indentation
      return ' ' * @spaces_per_indent * @indentation + @close
    else
      @close
    end
  end

  def indentation
    @indentation
  end

  def type
    @type
  end

  def identify_line
    @type = 'CSV_ARGS_LINE'
    @type = 'CSV_COFFEE_LINE'
    @type = 'CSV_LINE'
  end

  def current_state
    @state.last
  end

  def state_changed(new_state)
    if new_state == 'tag'
      @tokens['tag'] = ''

    elsif new_state == 'class'
      @tokens['classes'] << ''

    elsif new_state == 'attr_name'
      @current_attribute_name = ''

    elsif new_state == 'attr_value'
      @current_attribute_value = ''

    elsif new_state == 'none'
      if current_state == 'attr_name'
        @tokens['attr'][@current_attribute_name.strip] = true

      elsif current_state == 'attr_value'
        @tokens['attr'][@current_attribute_name.strip] = @current_attribute_value.strip
      end
    end

    @state << new_state

  end

  def update_state
    new_state = nil

    if ['tag', 'class', 'id', 'none'].include? current_state
      if @char == '#'
        new_state = 'id'
      elsif @char == '.' then
        new_state = 'class'
      elsif @char == '%' then
        new_state = 'tag'
      elsif @char == ' ' then
        new_state = 'text' #must be terminal state
      elsif @char == '{' then
        new_state = 'attr_name'
      end

    elsif current_state == 'attr_name'
      if @char == '='
        new_state = 'attr_value'
      end

    elsif current_state == 'attr_value'
      if @char == '}'
        new_state = 'none'
      end
    end

    if new_state
      state_changed new_state
      return true
    end
  end

  def take_action
    if ['tag', 'id', 'text'].include? current_state
      @tokens[current_state] += @char

    elsif current_state == 'class'
      @tokens['classes'][-1] += @char

    elsif current_state == 'attr_name'
      @current_attribute_name += @char

    elsif current_state == 'attr_value'
      @current_attribute_value += @char

    end
  end

  def preprocess_line
    @indentation = @line.scan(/^\s*/)[0].size/@spaces_per_indent
    @line.strip!

    parts = @line.split('#{')

    if parts.length > 1
      part_0 = parts[0]
      parts = parts[1..-1].map { |part|
        part.sub '}', 'CSJV_INTERPOLATE_CLOSE'
      }
      @line = part_0+'CSJV_INTERPOLATE_OPEN'+parts.join('CSJV_INTERPOLATE_OPEN')
    end
  end

  def postprocess_html
    @html = @html
      .gsub('CSJV_INTERPOLATE_OPEN', '#{')
      .gsub('CSJV_INTERPOLATE_CLOSE', '}')
      .gsub('"', '\"')
  end

  def parse
    preprocess_line

    @line.each_char do |char|
      @char = char
      next if self.update_state
      self.take_action
    end

    generate_html
  end

  def is_self_enclosed_tag?
    @self_enclosed_tags.include? @tokens['tag']
  end

  def generate_html
    @html = '<'+@tokens['tag']
    @html += ' id="'+@tokens['id'].strip+'"' unless @tokens['id'].empty?
    @html += ' class="'+@tokens['classes'].join(' ').strip+'"' unless @tokens['classes'].empty?

    @tokens['attr'].each_pair do |k,v|
      k = 'data'+k if k[0].chr == '-'
      @html += " #{k}=\"#{v}\""
    end if @tokens['attr'] != nil

    if is_self_enclosed_tag? then
      @close = false
      @html += '/>'
    else
      @close = '</'+@tokens['tag']+'>'
      @html += '>'
    end

    @html += @tokens['text'] unless @tokens['text'].empty?
    postprocess_html
  end
end
