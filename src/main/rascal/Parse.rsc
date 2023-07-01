module Parse

import Main;
import ParseTree;
Exp parseExp(str txt) = parse(#Exp, txt);