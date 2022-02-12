let config_list = [
  \ '~plug.vim',
  \ 'autocommand.vim',
  \ 'indentline.vim',
  \ 'mapping.vim',
  \ 'theme.vim',
  \ 'airline.vim',
  \ 'setter.vim',
  \ 'ale.vim',
  \ 'theme_sonokai.vim'
  \ ]

for files in config_list
  exec 'runtime config/' . files
endfor

set secure
