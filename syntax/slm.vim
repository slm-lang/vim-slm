" Vim syntax file
" Language: Slm
" Maintainer: Yury Korolev <yurykorolev@me.com>
" Version:  1
" Last Change:  2014 Dec 26
" TODO: Feedback is welcomed.

" Quit when a syntax file is already loaded.
if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'slm'
endif

" Allows a per line syntax evaluation.
let b:js_no_expensive = 1

" Include Javascript syntax highlighting
syn include @slmJSTop syntax/javascript.vim
unlet! b:current_syntax
" Include Haml syntax highlighting
syn include @slmHaml syntax/haml.vim
unlet! b:current_syntax

syn match slmBegin  "^\s*\(&[^= ]\)\@!" nextgroup=slmTag,slmClassChar,slmIdChar,slmJS

syn region  jsCurlyBlock start="{" end="}" contains=@slmJSTop contained
syn cluster slmJSTop    add=jsCurlyBlock

syn cluster slmComponent contains=slmClassChar,slmIdChar,slmWrappedAttrs,slmJS,slmAttr,slmInlineTagChar

syn keyword slmDocType        contained html 5 1.1 strict frameset mobile basic transitional
syn match   slmDocTypeKeyword "^\s*\(doctype\)\s\+" nextgroup=slmDocType

syn keyword slmTodo        FIXME TODO NOTE OPTIMIZE XXX contained
syn keyword htmlTagName     contained script

syn match slmTag           "\w\+[><]*"    contained contains=htmlTagName nextgroup=@slmComponent
syn match slmIdChar        "#{\@!"        contained nextgroup=slmId
syn match slmId            "\%(\w\|-\)\+" contained nextgroup=@slmComponent
syn match slmClassChar     "\."           contained nextgroup=slmClass
syn match slmClass         "\%(\w\|-\)\+" contained nextgroup=@slmComponent
syn match slmInlineTagChar "\s*:\s*"      contained nextgroup=slmTag,slmClassChar,slmIdChar

syn region slmWrappedAttrs matchgroup=slmWrappedAttrsDelimiter start="\s*{\s*" skip="}\s*\""  end="\s*}\s*"  contained contains=slmAttr nextgroup=slmJS
syn region slmWrappedAttrs matchgroup=slmWrappedAttrsDelimiter start="\s*\[\s*" end="\s*\]\s*" contained contains=slmAttr nextgroup=slmJS
syn region slmWrappedAttrs matchgroup=slmWrappedAttrsDelimiter start="\s*(\s*"  end="\s*)\s*"  contained contains=slmAttr nextgroup=slmJS

syn match slmAttr /\s*\%(\w\|-\)\+\s*=/me=e-1 contained contains=htmlArg nextgroup=slmAttrAssignment
syn match slmAttrAssignment "\s*=\s*" contained nextgroup=slmWrappedAttrValue,slmAttrString

syn region slmWrappedAttrValue start="[^"']" end="\s\|$" contained contains=slmAttrString,@slmJSTop nextgroup=slmAttr,slmJS,slmInlineTagChar
syn region slmWrappedAttrValue matchgroup=slmWrappedAttrValueDelimiter start="{" end="}" contained contains=slmAttrString,@slmJSTop nextgroup=slmAttr,slmJS,slmInlineTagChar
syn region slmWrappedAttrValue matchgroup=slmWrappedAttrValueDelimiter start="\[" end="\]" contained contains=slmAttrString,@slmJSTop nextgroup=slmAttr,slmJS,slmInlineTagChar
syn region slmWrappedAttrValue matchgroup=slmWrappedAttrValueDelimiter start="(" end=")" contained contains=slmAttrString,@slmJSTop nextgroup=slmAttr,slmJS,slmInlineTagChar

syn region slmAttrString start=+\s*"+ skip=+\%(\\\\\)*\\"+ end=+"\s*+ contained contains=slmInterpolation,slmInterpolationEscape nextgroup=slmAttr,slmJS,slmInlineTagChar
syn region slmAttrString start=+\s*'+ skip=+\%(\\\\\)*\\"+ end=+'\s*+ contained contains=slmInterpolation,slmInterpolationEscape nextgroup=slmAttr,slmJS,slmInlineTagChar

syn region slmInnerAttrString start=+\s*"+ skip=+\%(\\\\\)*\\"+ end=+"\s*+ contained contains=slmInterpolation,slmInterpolationEscape nextgroup=slmAttr
syn region slmInnerAttrString start=+\s*'+ skip=+\%(\\\\\)*\\"+ end=+'\s*+ contained contains=slmInterpolation,slmInterpolationEscape nextgroup=slmAttr

syn region slmInterpolation matchgroup=slmInterpolationDelimiter start="${" end="}" contains=@hamlJSTop containedin=javascriptStringS,javascriptStringD,slmWrappedAttrs
syn region slmInterpolation matchgroup=slmInterpolationDelimiter start="${=" end="}" contains=@hamlJSTop containedin=javascriptStringS,javascriptStringD,slmWrappedAttrs
syn match  slmInterpolationEscape "\\\@<!\%(\\\\\)*\\\%(\\\ze#{\|#\ze{\)"

syn region slmJS matchgroup=slmJSOutputChar start="\s*[=]\==[']\=" skip="\%\(,\s*\|\\\)$" end="$" contained contains=@slimJSTop keepend
syn region slmJS matchgroup=slmJSChar       start="\s*-"           skip="\%\(,\s*\|\\\)$" end="$" contained contains=@slimJSTop keepend

syn match slmComment /^\(\s*\)[/].*\(\n\1\s.*\)*/ contains=slmTodo
syn match slmText    /^\(\s*\)[`|'].*\(\n\1\s.*\)*/ contains=slmInterpolation

syn match slmFilter /\s*\w\+:\s*/                            contained
syn match slmHaml   /^\(\s*\)\<haml:\>.*\(\n\1\s.*\)*/       contains=@slmHaml,slmFilter
syn match slmJSTop  /^\(\s*\)script:.*\(\n\1\s.*\)*/       contains=@slmJSTop,slmFilter

syn match slmIEConditional "\%(^\s*/\)\@<=\[\s*if\>[^]]*]" contained containedin=slmComment

hi def link slmAttrString                String
hi def link slmBegin                     String
hi def link slmClass                     Type
hi def link slmAttr                      Type
hi def link slmClassChar                 Type
hi def link slmComment                   Comment
hi def link slmDocType                   Identifier
hi def link slmDocTypeKeyword            Keyword
hi def link slmFilter                    Keyword
hi def link slmIEConditional             SpecialComment
hi def link slmId                        Identifier
hi def link slmIdChar                    Identifier
hi def link slmInnerAttrString           String
hi def link slmInterpolationDelimiter    Delimiter
hi def link slmJSChar                    Special
hi def link slmJSOutputChar              Special
hi def link slmText                      String
hi def link slmTodo                      Todo
hi def link slmWrappedAttrValueDelimiter Delimiter
hi def link slmWrappedAttrsDelimiter     Delimiter
hi def link slmInlineTagChar             Delimiter

let b:current_syntax = "slm"
