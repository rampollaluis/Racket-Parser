# Racket-Parser

This was done as a part of an assignment for my Programming Languages course on Spring 2018

The goal of the assignment was to implement a lexer and parser in the programming language Racket to determine whether a code given was syntactically correct, according to the professors made up language. Given the language tokens and grammar, I first implemented the lexer, creating definitions for what were considered characters, digits, operators, etc. in the language and building on top of that for more complex rules such as an expression, term, factor, etc. After, a **very** simple parser was added, which just parses everything into a string "OKAY" which outputs to the console in the case that the lexer doesn't throw an incorrect syntax exception.

The most challenging part of this assignment was by far working with Racket. As a language based on Scheme, this was a syntax and a way of writing code I had never encountered before and which made the assignment very tedious since we were not only learning about lexers and parsers, but also a completely different the language from what we are used to at the same time.
