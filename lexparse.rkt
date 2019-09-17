#lang racket
(require parser-tools/yacc
         parser-tools/lex
         (prefix-in : parser-tools/lex-sre)
         syntax/readerr)

;;; starting code from https://stackoverflow.com/questions/32928656/racket-define-one-character-with-token-char

(define-lex-abbrevs
  [letter     (:or (:/ "a" "z") (:/ #\A #\Z) )]
  [digit      (:/ #\0 #\9)]
  [character  (:or letter "?" "_")]
  )

(define-tokens value-tokens (CHARACTER
                             INT
                             DELIMITER
                             OPERATOR
                             IF
                             THEN
                             ELSE
                             LET
                             IN
                             MAP
                             TO
                             LPAREN
                             RPAREN
                             EMPTY
                             BOOL
                             SIGN
                             PRIM
                             ID
                             ASSIGN
                             SEMICOLON
                             COMMA
                             WIGGLY
                             ))

(define-empty-tokens op-tokens (newline EOF))

;;;;;;;;;;;;LEXER;;;;;;;;;;;;;;;
(define lex
  (lexer
   [(eof)
    'EOF]

   [(:or #\tab #\space #\newline)
    (lex input-port)]

   [#\newline
    (token-newline)]

   [(:or "+" "-")
    'SIGN]

   [(:or "*" "/" "=" "!=" "<" ">" "<=" ">=" "&" "|")
    'OPERATOR]

   ["("
    'LPAREN]

   [")"
    'RPAREN]

   ["if"
    'IF]

   ["then"
    'THEN]

   ["else"
    'ELSE]

   ["let"
    'LET]

   ["in"
    'IN]

   ["map"
    'MAP]

   ["to"
    'TO]

   ["empty"
    'EMPTY]

   [(:or "true" "false")
    'BOOL]

   [(:or "number?" "function?" "list?" "empty?" "cons?" "cons" "first" "rest" "arity")
    'PRIM]

   [":="
    'ASSIGN]

   [";"
    'SEMICOLON]

   [","
    'COMMA]

   ["~"
    'WIGGLY]

   [(:+ digit)
    'INT]

   [(:: character (:* (:or character digit)))
    'ID]

   [(:or letter "?" "_")
    'CHARACTER]

   [(:or "[" "]")
    'DELIMITER]

   ))
;;;;;;;;;;PARSER;;;;;;;;;;;;;
(define myparser
           (parser
            (start exp)
            (end EOF)
            (suppress)
            (tokens value-tokens op-tokens)
            (error "The code is not syntactically correct")
            (grammar
             (exp ((term binop exp) "OKAY")
                  ((term) "OKAY")
                  ((IF exp THEN exp ELSE exp) "OKAY")
                  ((LET def IN exp) "OKAY")
                  ((MAP idlist TO exp) "OKAY"))
             (term ((unop term) "OKAY")
                   ((factor LPAREN explist RPAREN) "OKAY")
                   ((factor) "OKAY")
                   ((EMPTY) "OKAY")
                   ((INT) "OKAY")
                   ((BOOL) "OKAY"))
             (factor ((LPAREN exp RPAREN) "OKAY")
                     ((PRIM) "OKAY")
                     ((ID) "OKAY"))
             (explist (() "OKAY")
                      ((propexplist) "OKAY"))
             (propexplist ((exp COMMA propexplist) "OKAY")
                          ((exp) "OKAY"))
             (idlist (() "OKAY")
                     ((propidlist) "OKAY"))
             (propidlist ((ID COMMA propidlist) "OKAY")
                         ((ID) "OKAY"))
             (def ((ID ASSIGN exp SEMICOLON def) "OKAY")
                  ((ID ASSIGN exp SEMICOLON) "OKAY"))
             (unop ((SIGN) "OKAY")
                   ((WIGGLY) "OKAY"))
             (binop ((SIGN) "OKAY")
                    ((OPERATOR) "OKAY"))
             )
            ))


(define (string->tokens s)
  (port->tokens (open-input-string s)))

(define (port->tokens in)
  (define token (lex in))
  (if (eq? token 'EOF)
      '()
      (cons token (port->tokens in))))

;;;;;CHANGE PATH TO TEST OTHER FILES;;;;;;;
(define file (file->string "Test"))

(define (lex-this lexer input) (lambda () (lexer input)))

;;;;MANUAL TEST;;;;;
;(myparser (lex-this lex (open-input-string "if 4 then 5 else 9")))

(myparser (lex-this lex (open-input-string file)))