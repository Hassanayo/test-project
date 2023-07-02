module Func::Eval1

// support for let expressions, this requires an extra enviroment for <name, value> bindings

import Func::AST;
import List;

alias Env = map[str, int];
alias PEnv = map[str, Func];

int eval1(str main, list[int] args, Prog prog) {
  penv = (f.name: f | f <- prog.funcs );
  f = penv[main];
  env = (f.formals[i] : args[i] | i <- index(f.formals) );
  return eval1(f.body, env, penv);
}

int eval1(nat(int nat), Env env, PEnv penv) = nat;

int eval1(var(str n), Env env, PEnv penv)  = env[n];

int eval1(mul(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) * eval1(rhs, env, penv);
    
int eval1(div(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) / eval1(rhs, env, penv);
    
int eval1(add(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) + eval1(rhs, env, penv);
    
int eval1(sub(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) - eval1(rhs, env, penv);
    
int eval1(gt(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) > eval1(rhs, env, penv) ? 1 : 0;
    
int eval1(lt(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) < eval1(rhs, env, penv) ? 1 : 0;
    
int eval1(geq(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) >= eval1(rhs, env, penv) ? 1 : 0;
    
int eval1(leq(Exp lhs, Exp rhs), Env env, PEnv penv) = 
    eval1(lhs, env, penv) <= eval1(rhs, env, penv) ? 1 : 0;
  
int eval1(cond(Exp cond, Exp then, Exp otherwise), Env env, PEnv penv) =             
    (eval1(cond, env, penv) != 0) ? eval1(then, env, penv) : eval1(otherwise, env, penv);
                 
int eval1(call(str name, list[Exp] args), Env env, PEnv penv) {
   f = penv[name];
   env =  ( f.formals[i]: eval1(args[i], env, penv) | i <- index(f.formals) );
   return eval1(f.body, env, penv);
}
         
int eval1(let(list[Binding] bindings, Exp exp), Env env, PEnv penv) {
   env += ( b.var : eval1(b.exp, env, penv) | b <- bindings );  
   return eval1(exp, env, penv);  
}
