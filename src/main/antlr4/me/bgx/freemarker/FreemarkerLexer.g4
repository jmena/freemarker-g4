lexer grammar FreemarkerLexer;


// STARTING GRAMMAR RULES
COMMENT             : COMMENT_FRAG -> skip;
START_DIRECTIVE_TAG : '<#' -> pushMode(EXPR_MODE);
END_DIRECTIVE_TAG   : '</#' -> pushMode(EXPR_MODE);
INLINE_EXPR_START   : '${' -> pushMode(EXPR_MODE);
CONTENT             : ('<' | '$' | ~[$<]+) ;

// MODES
mode DOUBLE_QUOTE_STRING_MODE;
DQS_EXIT       : '"' -> popMode;
DQS_ESCAPE     : '\\' [\\"$n];
DQS_ENTER_EXPR : '${' -> pushMode(EXPR_MODE);
DQS_CONTENT    : (~[\\$"])+;

mode SINGLE_QUOTE_STRING_MODE;
SQS_EXIT       : '\'' -> popMode;
SQS_ESCAPE     : '\\' [\\'$n];
SQS_ENTER_EXPR : '${' -> pushMode(EXPR_MODE);
SQS_CONTENT    : (~[\\$'])+;

mode EXPR_MODE;
// Keywords
EXPR_IF               : 'if';
EXPR_ELSE             : 'else';
EXPR_ELSEIF           : 'elseif';
EXPR_ASSIGN           : 'assign';
EXPR_AS               : 'as';
EXPR_LIST             : 'list';
EXPR_TRUE             : 'true';
EXPR_FALSE            : 'false';
// Other symbols
EXPR_NUM              : NUMBER;
EXPR_EXIT_R_BRACE     : '}' -> popMode;
EXPR_EXIT_GT          : '>' -> popMode;
EXPR_WS               : [ ]+ -> skip;
EXPR_COMENT           : COMMENT_FRAG -> skip;
EXPR_STRUCT           : '{'+ -> pushMode(EXPR_MODE);
EXPR_DOUBLE_STR_START : '"' -> pushMode(DOUBLE_QUOTE_STRING_MODE);
EXPR_SINGLE_STR_START : '\'' -> pushMode(SINGLE_QUOTE_STRING_MODE);
EXPR_QUESTION         : '?';
EXPR_BANG             : '!';
EXPR_EQ               : '=';
EXPR_ADD              : '+';
EXPR_SUB              : '-';
EXPR_MUL              : '*';
EXPR_DIV              : '/';
EXPR_L_PAREN          : '(';
EXPR_R_PAREN          : ')';
EXPR_COMPARE_EQ       : '==';
EXPR_LOGICAL_AND      : '&&';
EXPR_LOGICAL_OR       : '||';
EXPR_DOT              : '.';
EXPR_COMMA            : ',';
EXPR_COLON            : ':';
EXPR_SYMBOL           : SYMBOL;

// FRAGMENTS
fragment COMMENT_FRAG : '<#--' .*? '-->';
fragment NUMBER       : [0-9]+ ('.' [0-9]* )?;
fragment SYMBOL       : [_a-zA-Z][_a-zA-Z0-9]*;
