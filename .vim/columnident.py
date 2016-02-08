import re
import sys

TAB_SIZE = 4
MAX_FUNCDECL_LINETABCOUNT = 116
MIN_FIRST_COLUMN_TABCOUNT = 16
PYTHON_FILE = False

if len( sys.argv ) == 2 and sys.argv[ 1 ].endswith( ".py" ):
	PYTHON_FILE = True

def roundUp( value ):
	reminder = value % TAB_SIZE
	if reminder == 0:
		return value
	return value + TAB_SIZE - reminder

def countTabs( string ):
	result = 0
	string = [ c for c in string ]
	while len( string ) > 0:
		char = string.pop( 0 )
		if char == '\t':
			result = roundUp( result + 1 )
		else:
			result += 1
	return result

def tokenize( string ):
	return [ t for t in re.split( r'(\W)' , string ) if len( t ) > 0 ]

def isFunction( string ):
	assert not isCall( string )
	return re.search( r'\(.*\)' , string , re.DOTALL ) is not None

def isCall( string ):
	return	re.search( r'\(.*\);' , string , re.DOTALL ) is not None or \
			re.search( r'\(.*\)' , string , re.DOTALL ) is not None and PYTHON_FILE

def splitByZeroParenLevelComma( string ):
	tokens = tokenize( string )
	parts = [[]]
	parenLevel = 0
	while len( tokens ) > 0:
		token = tokens.pop( 0 )
		if token in [ '(' , '[' , '{' ]:
			parenLevel += 1
		elif token in [ ')' , ']' , '}' ]:
			parenLevel -= 1
		elif token == "'" or token == '"':
			parts[ -1 ] += stringLiteralFromTokens( tokens , token )
			continue
		elif token == ',' and parenLevel == 0:
			parts.append( [] )
			continue
		parts[ -1 ].append( token )
	return [ "".join( p ) for p in parts ]

def stringLiteralFromTokens( tokens , firstChar ):
	result = [ firstChar ]
	ignoreNext = False
	while len( tokens ) > 0:
		token = tokens.pop( 0 )
		result.append( token )
		if ( token == firstChar and not ignoreNext ):
			break
		ignoreNext = token == '\\'
	return "".join( result )

def splitFunction( string ):
	tokens = tokenize( string )
	upToParenthesis = "".join( tokens[ : tokens.index( '(' ) + 1 ] )
	tokens.reverse()
	afterParenthesisList = tokens[ : tokens.index( ')' ) + 1 ]
	afterParenthesisList.reverse()
	afterParenthesis = "".join( afterParenthesisList )
	parametersString = string[ len( upToParenthesis ) : - len( afterParenthesis ) ].strip()
	parameters = splitByZeroParenLevelComma( parametersString.strip() )
	return	upToParenthesis , \
			[ splitParameterIntoTwoColumns( p ) + ( p.strip(), ) for p in parameters ] , \
			afterParenthesis

def splitParameterIntoTwoColumns( parameter ):
	parameter = parameter.strip()
	tokens = tokenize( parameter )
	splitPoint = len( tokens )
	if '[' in tokens and tokens.index( '[' ) < splitPoint:
		splitPoint = tokens.index( '[' )
	if '=' in tokens and tokens.index( '=' ) < splitPoint:
		splitPoint = tokens.index( '=' )
	if splitPoint > 0:
		splitPoint -= 1
	while splitPoint > 0 and tokens[ splitPoint ].isspace():
		splitPoint -= 1
	return "".join( tokens[ : splitPoint ] ).strip() , "".join( tokens[ splitPoint : ] )

def completeToTabCount( string , tabCount ):
	remaining = tabCount - countTabs( string )
	assert remaining >= 0
	return string + "\t" * ( roundUp( remaining ) / TAB_SIZE )

def processFunction( input ):
	assert isFunction( input )
	upToParen , parameters , afterParens = splitFunction( input )
	firstColumnTabCount = roundUp( countTabs( upToParen ) + 1 )
	secondColumnTabCount = max( [ countTabs( p[ 0 ] ) for p in parameters ] )
	if secondColumnTabCount > 0:
		secondColumnTabCount = roundUp( secondColumnTabCount + 2 )
	parameters = [ completeToTabCount( p[ 0 ] , secondColumnTabCount ) + p[ 1 ] for p in parameters ]
	maxParameterTabCount = max( [ countTabs( p ) for p in parameters ] )
	maxLineTabCount = firstColumnTabCount + maxParameterTabCount 
	if maxLineTabCount > MAX_FUNCDECL_LINETABCOUNT:
		if maxParameterTabCount <= MAX_FUNCDECL_LINETABCOUNT - MIN_FIRST_COLUMN_TABCOUNT:
			firstColumnTabCount = MAX_FUNCDECL_LINETABCOUNT - maxParameterTabCount
		else:
			firstColumnTabCount = MIN_FIRST_COLUMN_TABCOUNT
		firstParameterGap = "\n" + "\t" * ( firstColumnTabCount / TAB_SIZE ) 
	else:
		firstParameterGap = "\t"
	result = upToParen + firstParameterGap + \
				( ",\n" + "\t" * ( firstColumnTabCount / TAB_SIZE ) ).join( parameters ) + \
				" " + afterParens
	return result

def processCall( input ):
	assert isCall( input )
	upToParen , parameters , afterParens = splitFunction( input )
	parameters = [ p[ 2 ] for p in parameters ]
	firstColumnTabCount = roundUp( countTabs( upToParen ) + 1 )
	maxParameterTabCount = max( [ countTabs( p ) for p in parameters ] )
	maxLineTabCount = firstColumnTabCount + maxParameterTabCount 
	if maxLineTabCount > MAX_FUNCDECL_LINETABCOUNT:
		if maxParameterTabCount <= MAX_FUNCDECL_LINETABCOUNT - MIN_FIRST_COLUMN_TABCOUNT:
			firstColumnTabCount = MAX_FUNCDECL_LINETABCOUNT - maxParameterTabCount
		else:
			firstColumnTabCount = MIN_FIRST_COLUMN_TABCOUNT
		firstParameterGap = "\n" + "\t" * ( firstColumnTabCount / TAB_SIZE ) 
	else:
		firstParameterGap = "\t"
	result = upToParen + firstParameterGap + \
				( ",\n" + "\t" * ( firstColumnTabCount / TAB_SIZE ) ).join( parameters ) + \
				" " + afterParens
	return result

def splitMemberDeclarations( input ):
	members = [ m.strip() for m in input.split( ';' ) ]
	assert len( members ) > 0
	if members[ -1 ] == "":
		members.pop()
	return [ splitParameterIntoTwoColumns( m ) for m in members ]

def processMemberDeclarations( input ):
	assert not isFunction( input )
	spaceBeforeFirstMember = re.search( r"^(\s*)" , input ).groups()[ 0 ]
	firstColumnTabCount = roundUp( countTabs( spaceBeforeFirstMember ) )
	members = splitMemberDeclarations( input )
	secondColumnTabCount = max( [ countTabs( m[ 0 ] ) for m in members ] )
	if secondColumnTabCount > 0:
		secondColumnTabCount = roundUp( secondColumnTabCount + 2 )
	members = [ completeToTabCount( m[ 0 ] , secondColumnTabCount ) + m[ 1 ] for m in members ]
	firstColumnTab = "\t" * ( firstColumnTabCount / TAB_SIZE )
	result = firstColumnTab + ( ";\n" + firstColumnTab ).join( members ) + ";"
	return result

inputLines = sys.stdin.readlines()
input = "".join( inputLines )

if len( [ l for l in inputLines if re.search( r"^\s*$" , l ) ] ) > 0:
	sys.stdout.write( "ERROR: Empty lines are not allowed in input" )
	exit( 1 )

if isCall( input ):
	sys.stdout.write( processCall( input ) )
elif isFunction( input ):
	sys.stdout.write( processFunction( input ) )
else:
	sys.stdout.write( processMemberDeclarations( input ) )
