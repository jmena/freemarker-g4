parser grammar FreemarkerParser;

options { tokenVocab=FreemarkerLexer; }


/** A rule called init that matches comma-separated values between {...}. */
template
  : elements EOF
  ;

elements
  : element*
  ;

element
  : rawText
  | directive
  | INLINE_EXPR_START inlineExpr EXPR_EXIT_R_BRACE
  ;

rawText
  : CONTENT+
  ;

directive
  : directiveIf
  | directiveAssign
  | directiveList
  | directiveInclude
  | directiveImport
  | directiveMacro
  | directiveNested
  | directiveReturn
  | directiveUser
  ;

directiveIf
    : START_DIRECTIVE_TAG EXPR_IF tagExpr EXPR_EXIT_GT elements
      (START_DIRECTIVE_TAG EXPR_ELSEIF EXPR_EXIT_GT elements )*
      (START_DIRECTIVE_TAG EXPR_ELSE EXPR_EXIT_GT elements)?
      END_DIRECTIVE_TAG EXPR_IF EXPR_EXIT_GT
    ;

directiveAssign
  : START_DIRECTIVE_TAG EXPR_ASSIGN EXPR_SYMBOL EXPR_EQ tagExpr EXPR_EXIT_GT
  ;

directiveList
  : START_DIRECTIVE_TAG EXPR_LIST tagExpr EXPR_AS EXPR_SYMBOL (EXPR_COMMA EXPR_SYMBOL)? EXPR_EXIT_GT
    elements
    (START_DIRECTIVE_TAG EXPR_ELSE EXPR_EXIT_GT elements)?
    END_DIRECTIVE_TAG EXPR_LIST EXPR_EXIT_GT
  ;

directiveInclude
  : START_DIRECTIVE_TAG EXPR_INCLUDE string EXPR_EXIT_GT
  ;

directiveImport
  : START_DIRECTIVE_TAG EXPR_IMPORT string EXPR_AS EXPR_SYMBOL EXPR_EXIT_GT
  ;

directiveMacro
  : START_DIRECTIVE_TAG EXPR_MACRO EXPR_SYMBOL (EXPR_SYMBOL)* EXPR_EXIT_GT
    elements                             
    END_DIRECTIVE_TAG EXPR_MACRO EXPR_EXIT_GT
  ;

directiveNested
  : START_DIRECTIVE_TAG EXPR_NESTED (expr (EXPR_COMMA expr)*)? EXPR_EXIT_GT
  ;

directiveReturn
  : START_DIRECTIVE_TAG EXPR_RETURN EXPR_EXIT_GT
  ;

directiveUser
  : START_USER_DIR_TAG EXPR_SYMBOL directiveUserParams EXPR_EXIT_DIV_GT
  | START_USER_DIR_TAG EXPR_SYMBOL directiveUserParams EXPR_EXIT_GT
    elements
    END_USER_DIR_TAG EXPR_SYMBOL (EXPR_SYMBOL EXPR_EQ expr)* EXPR_EXIT_GT
  ;

directiveUserParams
  : (EXPR_SYMBOL EXPR_EQ expr ( EXPR_SEMICOLON EXPR_SYMBOL (EXPR_COMMA EXPR_SYMBOL)* )?  )*
  | (expr (EXPR_COMMA expr)*)? ( EXPR_SEMICOLON EXPR_SYMBOL (EXPR_COMMA EXPR_SYMBOL)* )?
  ;

tagExpr: expr;

inlineExpr: expr;

string
  : single_quote_string
  | double_quote_string
  ;

expr
  : EXPR_NUM
  | EXPR_SYMBOL
  | string
  | struct

  // highest precedence operators
  | expr (EXPR_DOT EXPR_SYMBOL)+     // a.b element
  | expr (EXPR_QUESTION EXPR_SYMBOL)+
  | expr EXPR_L_PAREN (expr (EXPR_COMMA expr)* )? EXPR_R_PAREN
  | expr EXPR_L_SQ_PAREN expr EXPR_R_SQ_PAREN
  | EXPR_L_PAREN expr EXPR_R_PAREN

  // unary prefix operators
  | (EXPR_BANG|EXPR_SUB) expr

  // math operators
  | expr (EXPR_MUL|EXPR_DIV) expr
  | expr (EXPR_ADD|EXPR_SUB) expr

  // relational operators

  // equality
  | expr (EXPR_COMPARE_EQ) expr

  // logical "and" an "or" operators
  | expr EXPR_LOGICAL_AND expr
  | expr EXPR_LOGICAL_OR expr
  ;

struct
  : EXPR_STRUCT (struct_pair (EXPR_COMMA struct_pair)*)? EXPR_EXIT_R_BRACE
  ;

struct_pair: string EXPR_COLON expr;

single_quote_string
  : EXPR_SINGLE_STR_START (SQS_CONTENT | SQS_ESCAPE | SQS_ENTER_EXPR expr EXPR_EXIT_R_BRACE)* SQS_EXIT
  ;

double_quote_string
  : EXPR_DOUBLE_STR_START (DQS_CONTENT | DQS_ESCAPE | DQS_ENTER_EXPR expr EXPR_EXIT_R_BRACE)* DQS_EXIT
  ;
