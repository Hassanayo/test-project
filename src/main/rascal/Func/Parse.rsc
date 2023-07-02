module Func::Parse

// Parse a Func program from a string or file. Parsing uses the syntax rules for a given start non terminal to parse a string and turn it into a parse ParseTree


import Func::Func;
import ParseTree;

Prog parse(loc l) = parse(#Prog, l);
Prog parse(str s) = parse(#Prog, s);