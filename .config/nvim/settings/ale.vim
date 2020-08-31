let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\}

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" Signs
let g:ale_sign_error = '✕'
let g:ale_sign_warning = '⚠'

let g:ale_javascript_eslint_suppress_missing_config = 1
