""" Normal mode
" Tab like VSCode
nnoremap <Tab> >>
nnoremap <S-Tab> <<

""" Insert mode
"Revert Tab like VSCode
inoremap <S-Tab> <C-d>

""" NERDTree
" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

""" COC
map <silent> gd <Plug>(coc-definition)
map <silent> gy <Plug>(coc-type-definition)
map <silent> gi <Plug>(coc-implementation)
map <silent> gr <Plug>(coc-references)
