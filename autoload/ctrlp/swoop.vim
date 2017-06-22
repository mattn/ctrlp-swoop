if exists('g:loaded_ctrlp_swoop') && g:loaded_ctrlp_swoop
  finish
endif
let g:loaded_ctrlp_swoop = 1

let s:command = get(g:, 'ctrlp_swoop_command', 'ag --vimgrep %s')
let s:minlen = get(g:, 'ctrlp_swoop_minlen', 3)

function s:match(item)
	let str = a:item['str']
  if len(str) < s:minlen
    throw "too short"
  endif
  let command = stridx(s:command, '%s') != -1 ? printf(s:command, shellescape(str)) : (s:command . ' ' . shellescape(str))
	return split(system(command, "\n"))
endfunction

let s:swoop_var = {
\  'init':   'ctrlp#swoop#init()',
\  'accept': 'ctrlp#swoop#accept',
\  'lname':  'swoop',
\  'sname':  'swoop',
\  'matcher':  {'match': function('s:match'), 'arg_type': 'dict'},
\  'type':   'path',
\  'sort':   0,
\  'nolim':  1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:swoop_var)
else
  let g:ctrlp_ext_vars = [s:swoop_var]
endif

function! ctrlp#swoop#init()
  return []
endfunc

function! ctrlp#swoop#accept(mode, str)
  call ctrlp#exit()
  let token = split(a:str, ':')
  if len(token) > 0
	  call ctrlp#acceptfile(a:mode, token[0])
  endif
  if len(token) > 1
    exe 'norm! ' . token[1] . 'Gzz'
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#swoop#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2

