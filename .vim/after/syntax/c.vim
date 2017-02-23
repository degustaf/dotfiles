" Vim options for C source files beyond standard options.

set noexpandtab
:syn region myFold start="\#if" end="\#endif" transparent fold
:syn sync fromstart
set foldmethod=syntax
:hi Folded ctermbg=Black
