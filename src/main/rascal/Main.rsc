module Main

import String;
import ParseTree;
/*
data Exp
    = con(int n) //defines integer constants
    | mul(Exp e1, Exp e2)
    | add(Exp e1,  Exp e2)
    | div(Exp e1, Exp e2)
    ;

// interpreter that evaluates expressions
int eval(con(int n)) = n;
int eval(mul(Exp e1, Exp e2)) = eval(e1) * eval(e2);
int eval(add(Exp e1, Exp e2)) = eval(e1) + eval(e2);
int eval(div(Exp e1, Exp e2)) = eval(e1) / eval(e2);
*/

layout Whitespace = [\t-\n\r\ ]*;
lexical IntegerLiteral = [0-9]*;


start syntax Exp = 
    IntegerLiteral
    | bracket "(" Exp ")"
    > left mul: Exp "*" Exp
    > left add: Exp "+" Exp
    ;


//interpreter
int eval(str txt) = eval(parse(#Exp, txt));
int eval((Exp)`<IntegerLiteral l>`) = toInt("<l>");
int eval((Exp)`<Exp e1>*<Exp e2>`) = eval(e1) * eval(e2);
int eval((Exp)`<Exp e1>+<Exp e2>`) = eval(e1) + eval(e2);
int eval((Exp)`<Exp e>`) = eval(e);

test bool tstEval1() = eval("7") == 7;
test bool tstEval2() = eval("7*3") == 21;
test bool tstEval3() = eval("7+3") == 10;
test bool tstEval4() = eval("3+4*5") == 23;