@CJSV = 
  alface: () ->
    _outstream=""

    _oustream += "<p>Alface</p><p>Queijo</p><a>Limonada Suiça com Limão</a>"

  embedded_coffee: () ->
    _outstream=""

    _oustream += "<div id=\"level-0\">"
    if simple_nesting
      unless double_nesting
        _oustream += "<img id=\"inside-unless\" src=\"neymar.png\"/>"
      if omg
        for queijo in salada
          _oustream += "<span class=\"inside-if-and-for\">#{queijo}</span>"
      _oustream += "<div id=\"level-1\">"
      if jabuticaba == 'preta'
        _oustream += "<div id=\"inside-if\"></div>"
      _oustream += "<div id=\"level-0\"></div></div>"
    _oustream += "<div id=\"level-0\"></div></div><div id=\"level-0\"></div>"

  foo: (name) ->
    _outstream=""

    _oustream += "<p>Olá #{name}</p>"

  lines: () ->
    _outstream=""

    _oustream += "<p id=\"id\" class=\"two classe\" simple=\"attribute\">And text</p><p id=\"id\" class=\"one-class\" simple=\"#{variable_attribute}\">And text</p><p id=\"#{variable_id}\" class=\"one-class #{variable_class}\" simple=\"#{variable_attribute}\">And variable #{text}</p><span #{variable_attribute_name}=\"#{with_variable_attribute_value}\"></span><span multiple=\"attributes\" more-than=\"three\" attri=\"with space\" can_i_have=\"a lot of attrbutes?\" please=\"#{im begging you}\"></span>"

  structured: () ->
    _outstream=""

    _oustream += "<div><p><span><span><p><span><br/></span></p></span></span></p></div><div id=\"profile\"><div id=\"profile-picture\" data-source=\"img/profile picture.png\"><div id=\"profile-first-name\">#{first-name}<div id=\"profile-last-name\">#{last-name}</div></div></div></div>"

  sub:
    directories:
      must:
        semifinal: () ->      
          _outstream=""
      
          _oustream += "<div id=\"claro_ue\"></div>"

        work:
          final_showdown: () ->        
            _outstream=""
        
            _oustream += "<div class=\"i-have-one-class\"><p class=\"who-cares? ive-go-two\"><span class=\"keep talking bitches\"><span id=\"ids-4-the-win\" class=\"#{and_dynamic_class_name}\"><p can_i_have=\"a lot of attrbutes?\" please=\"#{im begging you}\"><span><br/></span></p></span></span></p></div><div id=\"profile\"><div id=\"profile-picture\" data-source=\"img/profile picture.png\"><div id=\"profile-name\">#{name}</div></div></div><div id=\"placeholder\"></div>"
