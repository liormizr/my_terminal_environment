function! ToggleTestNotest()
	let w:toggleTest = exists('w:toggleTest') ? !w:toggleTest : 0
	let w:declTest = "test"
	let w:declNotest = "notest"
	let w:ext = expand('%:e')
	if (w:ext == "py")
		let w:declFunc = "def "
	else
		let w:declFunc = "void "
	endif
	let w:testStr = w:declFunc . w:declTest
	let w:notestStr = w:declFunc . w:declNotest
	if (!w:toggleTest)
		:execute '%substitute/' . w:testStr . "/" . w:notestStr . "/g"
	else
		:execute '%substitute/' . w:notestStr . "/" . w:testStr . "/g"
	endif
endfunction

"Toggle test/notest function names in unittesting files"
map <S-T><S-T> :call ToggleTestNotest()<CR>
