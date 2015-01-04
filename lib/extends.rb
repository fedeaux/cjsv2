def extends()
  {
    'attributes_shortcuts' => {
      #Layout Shortcuts
      'dpp' => 'data-position-pos',
      'dpr' => 'data-position-rel'
    },
    'values_shortcuts' => {
      #Special Fields Plugin
      'data-validation-regex' => {'email' => '([A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4})|^$'}
    },
    'tags_shortcuts' => {
      '_cb' => {
        'tag' => 'input',
        'attributes' => {'type' => 'checkbox'}
      },
      '_bi' => {
        'tag' => 'input',
        'attributes' => {'type' => 'button'}
      },
      '_si' => {
        'tag' => 'input',
        'attributes' => {'type' => 'submit'}
      },
      '_rb' => {
        'tag' => 'input',
        'attributes' => {'type' => 'radio'}
      },
      '_ti' => {
        'tag' => 'input',
        'attributes' => {'type' => 'text'}
      },
      '_ei' => {
        'tag' => 'input',
        'attributes' => {'type' => 'email'}
      },
      '_ni' => {
        'tag' => 'input',
        'attributes' => {'type' => 'numeric'}
      },
      '_pi' => {
        'tag' => 'input',
        'attributes' => {'type' => 'password'}
      },
      '_fi' => {
        'tag' => 'input',
        'attributes' => {'type' => 'file'}
      },
      '_tai' => {
        'tag' => 'textarea',
        'attributes' => {}
      },
      '_hi' => {
        'tag' => 'input',
        'attributes' => {'type' => 'hidden'}
      }
    }
  }
end
