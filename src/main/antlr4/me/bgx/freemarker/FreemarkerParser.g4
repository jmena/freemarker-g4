/*
Copyright (c) 2018 Javier Mena

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
parser grammar FreemarkerParser;

options { tokenVocab=FreemarkerLexer; }

template
  : elements EOF
  ;

elements
  : element*
  ;

element
  : rawText                                           # RawTextElement
  | directive                                         # DirectiveElement
  | INLINE_EXPR_START inlineExpr EXPR_EXIT_R_BRACE    # InlineExprElement
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
  : START_DIRECTIVE_TAG EXPR_LIST tagExpr EXPR_AS (value=EXPR_SYMBOL | key=EXPR_SYMBOL EXPR_COMMA value=EXPR_SYMBOL) EXPR_EXIT_GT
    bodyElements=elements
    (START_DIRECTIVE_TAG EXPR_ELSE EXPR_EXIT_GT elseElements=elements)?
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
  : START_USER_DIR_TAG EXPR_SYMBOL (EXPR_DOT EXPR_SYMBOL)* directiveUserParams EXPR_EXIT_DIV_GT     # DirUserEmptyBody
  | START_USER_DIR_TAG EXPR_SYMBOL (EXPR_DOT EXPR_SYMBOL)* directiveUserParams EXPR_EXIT_GT
    elements
    END_USER_DIR_TAG EXPR_SYMBOL (EXPR_DOT EXPR_SYMBOL)* EXPR_EXIT_GT                   # DirUserWithBody
  ;

directiveUserParams
  : (EXPR_SYMBOL EXPR_EQ expr ( EXPR_SEMICOLON EXPR_SYMBOL (EXPR_COMMA EXPR_SYMBOL)* )?  )* # DirUserParamsNamed
  | (expr (EXPR_COMMA expr)*)? ( EXPR_SEMICOLON EXPR_SYMBOL (EXPR_COMMA EXPR_SYMBOL)* )?    # DirUserParamsPositional
  ;

tagExpr: expr;

inlineExpr: expr;

string
  : single_quote_string      # SingleQuote
  | double_quote_string      # DoubleQuote
  ;

expr
  : EXPR_NUM       # NumberExpr
  | EXPR_SYMBOL    # SymbolExpr
  | string         # StringExpr
  | struct         # StructExpr

  // highest precedence operators
  | expr (EXPR_DOT EXPR_SYMBOL)+                                  # ExprDotAccess
  | expr EXPR_QUESTION EXPR_QUESTION                              # ExprMissingTest
  | expr (EXPR_QUESTION EXPR_SYMBOL)+                             # ExprBuiltIn
  | funExpr=expr EXPR_L_PAREN (firstArg=expr (EXPR_COMMA restArgs=expr)* )? EXPR_R_PAREN    # ExprFunctionCall
  | expr EXPR_L_SQ_PAREN expr EXPR_R_SQ_PAREN                     # ExprSquareParentheses
  | EXPR_L_PAREN expr EXPR_R_PAREN                                # ExprRoundParentheses

  // unary prefix operators
  | op=(EXPR_BANG|EXPR_SUB) expr       # ExprUnaryOp

  // math operators
  | expr op=(EXPR_MUL|EXPR_DIV) expr   # ExprMulDiv
  | expr op=(EXPR_ADD|EXPR_SUB) expr   # ExprAddSub

  // relational operators

  // boolean equality
  | expr (EXPR_COMPARE_EQ) expr        # ExprBoolEq

  // logical "and" an "or" operators
  | expr EXPR_LOGICAL_AND expr         # ExprBoolAnd
  | expr EXPR_LOGICAL_OR expr          # ExprBoolOr
  ;

struct
  : EXPR_STRUCT (struct_pair (EXPR_COMMA struct_pair)*)? EXPR_EXIT_R_BRACE
  ;

struct_pair: (string | EXPR_SYMBOL) EXPR_COLON expr;

single_quote_string
  : EXPR_SINGLE_STR_START (SQS_CONTENT | SQS_ESCAPE | SQS_ENTER_EXPR expr EXPR_EXIT_R_BRACE)* SQS_EXIT
  ;

double_quote_string
  : EXPR_DOUBLE_STR_START (DQS_CONTENT | DQS_ESCAPE | DQS_ENTER_EXPR expr EXPR_EXIT_R_BRACE)* DQS_EXIT
  ;
