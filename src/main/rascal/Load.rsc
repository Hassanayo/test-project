module Load

import ParseTree;        
import Parse;

data Exp       
    = con(int n)                 
    | mul(Exp e1, Exp e2)        
    | add(Exp e1, Exp e2)        
    | div(Exp e1, Exp e2)
    ;
// interpreter that evaluates expressions
int eval(con(int n)) = n;
int eval(mul(Exp e1, Exp e2)) = eval(e1) * eval(e2);
int eval(add(Exp e1, Exp e2)) = eval(e1) + eval(e2);
int eval(div(Exp e1, Exp e2)) = eval(e1) / eval(e2);

Exp load(Tree t) = implode(#Exp, t); 