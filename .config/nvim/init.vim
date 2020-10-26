call plug#begin('~/.vim/plugged')

" Vim improvement plugins
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'Townk/vim-autoclose'
" Plug 'sheerun/vim-polyglot'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Theme
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'rbong/vim-crystalline'

" Buffer Management and search
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Linting and Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc-prettier'
" Plug 'neoclide/coc-eslint'
" Plug 'neoclide/coc-tabnine'
" Plug 'neoclide/coc-tsserver'
" Plug 'neoclide/coc-json'

" Rust
Plug 'rust-lang/rust.vim'

call plug#end()

"""""""""""""""""""""""""""""""""""
"
" General config
"
"""""""""""""""""""""""""""""""""""
let mapleader = ','
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set number
set mouse=a
set backupcopy=yes

" map leader x to close extra windows
noremap <leader>x :ccl <bar> lcl<CR>

" map leader y and p to paste buffer
set clipboard+=unnamedplus


""""""""""""""""""""""""""""""""""
"
" Custom keys
"
""""""""""""""""""""""""""""""""""
inoremap jj <Esc>
noremap <leader>. :update<CR>

"""""""""""""""""""""""""""""""""""
" 
" Theme
"
"""""""""""""""""""""""""""""""""""
set background=dark
colorscheme gruvbox 
" hi Normal ctermbg=none
syntax enable
set guifont=FiraCode\ Nerd\ Font,Unifont,Noto\ Color\ Emoji
" Crystalline
function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %t%h%w%m%r '
  if a:current
    let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
  endif

  let l:s .= '%='
  if a:current
    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":"" }'
    let l:s .= crystalline#left_mode_sep('')
  endif
  if a:width > 80
    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'onedark'

set guioptions-=e
set laststatus=2
set noshowmode

"""""""""""""""""""""""""""""""""""
"
" JSX
"
"""""""""""""""""""""""""""""""""""
let g:jsx_ext_required = 0

augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.tsx set filetype=typescript.tsx
augroup END

"""""""""""""""""""""""""""""""""""
"
" Splits
"
"""""""""""""""""""""""""""""""""""
set hidden
set splitbelow
set splitright 

"""""""""""""""""""""""""""""""""""
"
" Configuring Nerd Tree
"
"""""""""""""""""""""""""""""""""""

map <C-n> :NERDTreeToggle<CR>
map <leader>n :NERDTreeFocus<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"""""""""""""""""""""""""""""""""""
"
" Configuring fzf
"
"""""""""""""""""""""""""""""""""""
nmap ; :Buffers<CR>
nmap <Space> :GFiles<CR>
nmap <leader>r :Rg<CR>

"""""""""""""""""""""""""""""""""""
"
" Nerd commenter config
"
"""""""""""""""""""""""""""""""""""
let g:NERDSpaceDelims = 1


"""""""""""""""""""""""""""""""""""
"
" Move to word
"
"""""""""""""""""""""""""""""""""""

map  f <Plug>(easymotion-bd-f)
nmap f <Plug>(easymotion-overwin-f)
let g:EasyMotion_smartcase = 1

"""""""""""""""""""""""""""""""""""
"
" Configuring CoC 
"
"""""""""""""""""""""""""""""""""""


" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

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

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <silent>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <home>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <home>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <home>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <home>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <home>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <home>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <home>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <home>p  :<C-u>CocListResume<CR>

