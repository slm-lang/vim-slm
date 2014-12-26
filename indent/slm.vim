" Vim indent file
" Language:	Slm

if exists("b:did_indent")
  finish
endif
runtime! indent/javascript.vim
unlet! b:did_indent
let b:did_indent = 1

setlocal autoindent sw=2 et
setlocal indentexpr=GetSlmIndent()
setlocal indentkeys=o,O,*<Return>,},],0),!^F,=else

" Only define the function once.
if exists("*GetSlmIndent")
  finish
endif

let s:attributes = '\%({.\{-\}}\|\[.\{-\}\]\)'
let s:tag = '\%([%.#][[:alnum:]_-]\+\|'.s:attributes.'\)*[<>]*'

if !exists('g:haml_self_closing_tags')
  let g:haml_self_closing_tags = 'meta|link|img|hr|br'
endif

function! GetSlmIndent()
  let lnum = prevnonblank(v:lnum-1)
  if lnum == 0
    return 0
  endif
  let line = substitute(getline(lnum),'\s\+$','','')
  let cline = substitute(substitute(getline(v:lnum),'\s\+$','',''),'^\s\+','','')
  let lastcol = strlen(line)
  let line = substitute(line,'^\s\+','','')
  let indent = indent(lnum)
  let cindent = indent(v:lnum)
  if cline =~# '\v^-\s*%(else|when)>'
    let indent = cindent < indent ? cindent : indent - &sw
  endif
  let increase = indent + &sw
  if indent == indent(lnum)
    let indent = cindent <= indent ? -1 : increase
  endif

  let group = synIDattr(synID(lnum,lastcol,1),'name')

  if line =~ '^doctype'
    return indent
  elseif line =~ '^/\%(\[[^]]*\]\)\=$'
    return increase
  elseif line =~ '^[\.#]'
    return increase
  elseif line =~? '^div'
    return increase
  elseif group == 'hamlFilter'
    return increase
  elseif line =~ '^'.s:tag.'[&!]\=[=~-]\s*\%(\%(if\|else\|case\|when\|while\|until\|for)\>\%(.*\<end\>\)\@!\|.*do\%(\s*|[^|]*|\)\=\s*$\)'
    return increase
  elseif line =~ '^'.s:tag.'[&!]\=[=~-].*,\s*$'
    return increase
  elseif line == '-#'
    return increase
  elseif group =~? '\v^(hamlSelfCloser)$' || line =~? '^\v('.g:haml_self_closing_tags.')>'
    return indent
  elseif group =~? '\v^(hamlTag|hamlAttributesDelimiter|hamlObjectDelimiter|hamlClass|hamlId|htmlTagName|htmlSpecialTagName)$'
    return increase
  elseif synIDattr(synID(v:lnum,1,1),'name') ==? 'hamlRubyFilter'
    return GetRubyIndent()
  else
    return indent
  endif
endfunction

" vim:set sw=2:
