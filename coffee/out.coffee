@CJSV:
  alface: () ->
    _outstream=""

    _oustream += "<p>Alface"
    _oustream += "</p>"
    _oustream += "<p>Queijo"
    _oustream += "</p>"
    _oustream += "<a>Limonada Suiça com Limão"
    _oustream += "</a>"

  embedded_coffee: () ->
    _outstream=""

    _oustream += "<div id=\"level-0\">"
    if simple_nesting
      unless double_nesting
        _oustream += "      <img id=\"inside-unless\" src=\"neymar.png\"/>"
      if omg
        for queijo in salada
          _oustream += "        <span class=\"inside-if-and-for\">#{queijo}"
          _oustream += "        </span>"
      _oustream += "    <div id=\"level-1\">"
      if jabuticaba == 'preta'
        _oustream += "      <div id=\"inside-if\">"
        _oustream += "      </div>"
      _oustream += "    <div id=\"level-0\">"
      _oustream += "    </div>"
      _oustream += "    </div>"
    _oustream += "  <div id=\"level-0\">"
    _oustream += "  </div>"
    _oustream += "</div>"
    _oustream += "<div id=\"level-0\">"
    _oustream += "</div>"

  lines: () ->
    _outstream=""

    _oustream += "<p id=\"id\" class=\"two classe\" simple=\"attribute\">And text"
    _oustream += "</p>"
    _oustream += "<p id=\"id\" class=\"one-class\" simple=\"#{variable_attribute}\">And text"
    _oustream += "</p>"
    _oustream += "<p id=\"#{variable_id}\" class=\"one-class #{variable_class}\" simple=\"#{variable_attribute}\">And variable #{text}"
    _oustream += "</p>"
    _oustream += "<span #{variable_attribute_name}=\"#{with_variable_attribute_value}\">"
    _oustream += "</span>"
    _oustream += "<span multiple=\"attributes\" more-than=\"three\" attri=\"with space\" can_i_have=\"a lot of attrbutes?\" please=\"#{im begging you}\">"
    _oustream += "</span>"

  structured: () ->
    _outstream=""

    _oustream += "<div>"
    _oustream += "  <p>"
    _oustream += "    <span>"
    _oustream += "    <span>"
    _oustream += "  <p>"
    _oustream += "    <span>"
    _oustream += "    <br/>"
    _oustream += "    </span>"
    _oustream += "  </p>"
    _oustream += "    </span>"
    _oustream += "    </span>"
    _oustream += "  </p>"
    _oustream += "</div>"
    _oustream += "<div id=\"profile\">"
    _oustream += "  <div id=\"profile-picture\" data-source=\"img/profile picture.png\">"
    _oustream += "  <div id=\"profile-first-name\">#{first-name}"
    _oustream += "  <div id=\"profile-last-name\">#{last-name}"
    _oustream += "  </div>"
    _oustream += "  </div>"
    _oustream += "  </div>"
    _oustream += "</div>"

  sub:
    directories:
      must:
        semifinal: () ->      
          _outstream=""
      
          _oustream += "<div id=\"claro_ue\">"
          _oustream += "</div>"

        work:
          final_showdown: () ->        
            _outstream=""
        
            _oustream += "<div class=\"i-have-one-class\">"
            _oustream += "  <p class=\"who-cares? ive-go-two\">"
            _oustream += "    <span class=\"keep talking bitches\">"
            _oustream += "    <span id=\"ids-4-the-win\" class=\"#{and_dynamic_class_name}\">"
            _oustream += "  <p can_i_have=\"a lot of attrbutes?\" please=\"#{im begging you}\">"
            _oustream += "    <span>"
            _oustream += "    <br/>"
            _oustream += "    </span>"
            _oustream += "  </p>"
            _oustream += "    </span>"
            _oustream += "    </span>"
            _oustream += "  </p>"
            _oustream += "</div>"
            _oustream += "<div id=\"profile\">"
            _oustream += "  <div id=\"profile-picture\" data-source=\"img/profile picture.png\">"
            _oustream += "  <div id=\"profile-name\">#{name}"
            _oustream += "  </div>"
            _oustream += "  </div>"
            _oustream += "</div>"
            _oustream += "<div id=\"placeholder\">"
            _oustream += "</div>"
