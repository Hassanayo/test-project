module Func::Load

import Func::Func;
import Func::AST;
import Func::Parse;

import ParseTree;

Func::AST::Prog implode(Func::Func::Prog p) = 
    implode(#Func::AST::Prog, p);

Func::AST::Prog load(loc l) = implode(parse(l));
Func::AST::Prog load(str s) = implode(parse(s));