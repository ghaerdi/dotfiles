""" Normal mode
" Tab like VSCode
nnoremap <Tab> >>
nnoremap <S-Tab> <<

""" Insert mode
"Revert Tab like VSCode
inoremap <S-Tab> <C-d>

""" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

""" Open fzf
map <C-f> :Files<CR>
map <C-b> :Buffers<CR>
map <C-d> :bdelete<CR>

""" COC
map <silent> gd <Plug>(coc-definition)
map <silent> gy <Plug>(coc-type-definition)
map <silent> gi <Plug>(coc-implementation)
map <silent> gr <Plug>(coc-references)

""" Prettier
vmap <S-f>  :CocCommand prettier.formatFile<CR>
nmap <S-f>  :CocCommand prettier.formatFile<CR>
