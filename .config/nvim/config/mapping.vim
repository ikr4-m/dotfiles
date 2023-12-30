" explorer
nnoremap <space>e :CocCommand explorer<CR>

" Open coc diagnostic
nnoremap <space>d :CocCommand diagnostic<CR>

" fixing X can cut
map x "_d<CR>

" fixing <C-v> in wsl
nmap <Leader>v <C-v>

" Escape from terminal
tmap <Esc> <C-\><C-n>

" Resize vertical window
nmap <silent> <A-h> :vertical resize +1<CR>
nmap <silent> <A-l> :vertical resize -1<CR>
nmap <silent> <C-h> :vertical resize +50<CR>
nmap <silent> <C-l> :vertical resize -50<CR>

" Expand horizontal window
nmap <space>w <C-w>_
nmap <space>q <C-w>=

" Auto brace
inoremap { {}<Esc>i

" Wrap
nmap <space>p :set wrap<CR>
nmap <space><space>p : set wrap!<CR>

" Diagnostic
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Definition overload
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" PgDown PgUp for 60% Keyboard
nmap { <PageUp>
nmap } <PageDown>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" VScode Ctrl+D like
xmap <silent> <C-d> <Plug>(coc-cursors-range)
nmap <expr> <silent> <C-d> <SID>select_current_word()
function! s:select_current_word()
  if !get(b:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

" Load session
nmap <space>d :source .vimsession<CR>

" Save session
nmap <space>s :mks! .vimsession<CR>

" Search and replace
nmap <space>r :%s /

" Special for CS, omnisharp config
autocmd FileType cs nnoremap <silent> K :OmniSharpDocumentation<CR>

" Telescope shortcut
nnoremap <space>ff <cmd>Telescope find_files<cr>
nnoremap <space>fg <cmd>Telescope live_grep<cr>
nnoremap <space>fb <cmd>Telescope buffers<cr>
nnoremap <space>fh <cmd>Telescope help_tags<cr>
