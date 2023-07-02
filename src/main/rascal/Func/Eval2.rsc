module Func::Eval2

// like Eval! but with support for sequences and assignments, main additions are local side effects and sequence operator

import Func::AST;
import List;

alias Env = map[str, int];
alias PEnv = map[str, Func];

alias Result = tuple[Env, int];

Result eval2(str main, list[int] args, Prog prog) {
  penv = ( f.name: f | f <- prog.funcs );
  f = penv[main];
  env = ( f.formals[i] : args[i] | i <- index(f.formals) ); 
  return eval2(f.body, env, penv);
}

Result eval2(nat(int nat), Env env, PEnv penv) = <env, nat>;
 
Result eval2(var(str name), Env env, PEnv penv) = <env, env[name]>; 

Result eval2(mul(Exp lhs, Exp rhs), Env env, PEnv penv) {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, x * y>;
}

Result eval2(div(Exp lhs, Exp rhs), Env env, PEnv penv) {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, x / y>;
} 
      
Result eval2(add(Exp lhs, Exp rhs), Env env, PEnv penv)  {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, x + y>;
} 
      
Result eval2(sub(Exp lhs, Exp rhs), Env env, PEnv penv)  {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, x - y>;
} 
      
Result eval2(gt(Exp lhs, Exp rhs), Env env, PEnv penv)  {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, (x > y) ? 1 : 0>;
} 
      
Result eval2(lt(Exp lhs, Exp rhs), Env env, PEnv penv)  {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, (x < y) ? 1 : 0>;
} 
      
Result eval2(geq(Exp lhs, Exp rhs), Env env, PEnv penv)  {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, (x >= y) ? 1 : 0>;
} 
      
Result eval2(leq(Exp lhs, Exp rhs), Env env, PEnv penv)  {
  <env, x> = eval2(lhs, env, penv);
  <env, y> = eval2(rhs, env, penv);
  return <env, (x <= y) ? 1 : 0>;
} 
  
Result eval2(cond(Exp cond, Exp then, Exp otherwise), Env env, PEnv penv)  {
  <env, c> = eval2(cond, env, penv);
  return (c != 0) ? eval2(then, env, penv) : eval2(otherwise, env, penv);
}
      
Result eval2(call(str name, list[Exp] args), Env env, PEnv penv)  {
   f = penv[name];
   for (i <- index(f.formals)) {
     <env, v> = eval2(args[i], env, penv);
     env[f.formals[i]] = v;
   }
   return eval2(f.body, env, penv);
}
         
Result eval2(let(list[Binding] bindings, Exp exp), Env env, PEnv penv)  {
   for (b <- bindings) {
     <env, x> = eval2(b.exp, env, penv);
     env[b.var] = x;
   }
   return eval2(exp, env, penv);
} 
    
Result eval2(assign(var(str name), Exp exp), Env env, PEnv penv)  {      
  <env, v> = eval2(exp, env, penv);
  env[name] = v;
  return <env, v>;
}

Result eval2(seq(Exp lhs, Exp rhs), Env env, PEnv penv)  {
  <env, _> = eval2(lhs, env, penv);
  return eval2(rhs, env, penv);
}
