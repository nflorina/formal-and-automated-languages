import java.util.*;
import java.util.Stack;

%%
 
%class HelloLexer
%line
%column
%standalone
%int

%{
	LinkedHashMap<String, String> intMap  = new LinkedHashMap<>();
  	Stack<Expression> stack = new Stack<>();
  	int flagInteger = 0;
  	LinkedList<Expression> elems = new LinkedList<>();
  	int UnassignedVar;
  	int line;
%}

%eof{
	while (stack.size() != 0) {
		elems.add(stack.pop());
	}
	Collections.reverse(elems);
	Expression last = elems.pollLast();
	Expression plast = elems.pollLast();
	SequenceNode s = new SequenceNode(plast, last);
	while (elems.size() != 0) {
		s = new SequenceNode(elems.pollLast(), s);
	}
	ArrayList<Expression> finalArray = new ArrayList<>();
	finalArray.add(s);
	stack.push(new ExprList(finalArray));
%eof}

numbers = [1-9][0-9]* | 0
letters = [a-zA-Z]
int = "int"
equal = "="
semicolon = ";"
colon = ","
plus = [+]
divide = [/]
open = [(]
closed = [)]
booltrue = "true"
boolfalse = "false"
ifcond = "if"
elsecond = "else"
openb = [{]
closeb = [}]
greater = [>]
notnode = [!]
andnode = "&&"
whilen = "while"
 
%%
{whilen}	{ stack.push(new Symbol("while")); }
{notnode}	{ stack.push(new Symbol("!")); }
{openb}		{ stack.push(new Symbol("{")); }
{ifcond}	{ stack.push(new Symbol("if")); }
{elsecond}  { stack.push(new Symbol("else")); }
{boolfalse}	{ stack.push(new BoolNode(yytext(), false)); }
{booltrue}	{ stack.push(new BoolNode(yytext(), true));  }
{divide}	{ stack.push(new Symbol("/")); }
{plus}		{ stack.push(new Symbol("+")); }
{equal}    	{ stack.push(new Symbol("=")); }
{int}		{ flagInteger = 1; }
{open}		{ stack.push(new Symbol("(")); }

{numbers}	{ 
			if (stack.size()!=0 && (stack.peek() instanceof Symbol) && ((Symbol) (stack.peek())).symbol().equals("=")) {
				stack.pop();
				VariableNode variable = ((VariableNode)(stack.pop()));
				if (intMap.containsKey(variable.node())) {
					intMap.put(variable.node(), yytext());
				}
				stack.push(new EqualAss(variable, new IntNode(intMap.get(variable.node()))));
			} else if ( stack.size()!=0 && (stack.peek() instanceof Symbol) && ((Symbol) (stack.peek())).symbol().equals("+")) {
	 			stack.push(new IntNode(yytext()));
			} else if ( stack.size()!=0 && (stack.peek() instanceof Symbol) && ((Symbol) (stack.peek())).symbol().equals("(")) {
				stack.push(new IntNode(yytext()));
			} else if ( stack.size()!=0 && (stack.peek() instanceof Symbol) && ((Symbol) (stack.peek())).symbol().equals(">")) {
				stack.push(new IntNode(yytext()));
			} else if ( stack.size()!=0 && (stack.peek() instanceof Symbol) && ((Symbol) (stack.peek())).symbol().equals("/")) {
				stack.pop();
				if (stack.peek() instanceof IntNode ||
					 stack.peek() instanceof VariableNode ||
					 stack.peek() instanceof DivNode ||
					 stack.peek() instanceof BracketNode) { 
					stack.push(new DivNode(stack.pop(), new IntNode(yytext())));
				} else if (stack.peek() instanceof EqualAss) {
	 				EqualAss t = (EqualAss) stack.pop();
	 				VariableNode var = t.e1;
	 				IntNode num = t.e2;
	 				DivNode div = new DivNode(num, new IntNode(yytext()));
	 				stack.push(new EqualGeneral(var, div));
	 			} else if (stack.peek() instanceof EqualAssVarVar) {
	 				EqualAssVarVar t = (EqualAssVarVar) stack.pop();
	 				VariableNode v1 = t.e1;
	 				VariableNode v2 = t.e2;
	 				DivNode div = new DivNode(v2, new IntNode(yytext()));
	 				stack.push(new EqualGeneral(v1, div));
	 			} else if (stack.peek() instanceof EqualGeneral) {
	 				EqualGeneral eq = (EqualGeneral) stack.pop();
	 				Expression o1 = eq.e1;
	 				Expression o2 = eq.e2;
	 				DivNode div = new DivNode(o2, new IntNode(yytext()));
	 				stack.push(new EqualGeneral(o1, div));
	 			}		
		}
}


{letters}	{ 
		if (flagInteger == 1) {
			intMap.put(yytext(), "null");
		} else {
			if (stack.size()!=0 && stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("=")) {
				stack.pop();
				VariableNode v = ((VariableNode) (stack.pop()));
				String new_value = yytext();
				EqualAssVarVar x = new EqualAssVarVar(new VariableNode(v.node()), new VariableNode(new_value));
				stack.push(x);
				String value_letter = intMap.get(new_value);
				intMap.put(v.node(), value_letter);
			} else if (stack.size()!=0 && (stack.peek() instanceof Symbol) && ((Symbol) (stack.peek())).symbol().equals("/")){
				stack.pop();
				if (stack.peek() instanceof IntNode ||
					 stack.peek() instanceof VariableNode ||
					 stack.peek() instanceof DivNode ||
					 stack.peek() instanceof BracketNode) {
					stack.push(new DivNode(stack.pop(), new VariableNode(yytext())));
				} else  if (stack.peek() instanceof EqualAss) {
	 				EqualAss t = (EqualAss) stack.pop();
	 				VariableNode var = t.e1;
	 				IntNode num = t.e2;
	 				DivNode div = new DivNode(num, new VariableNode(yytext()));
	 				stack.push(new EqualGeneral(var, div));
	 			} else if (stack.peek() instanceof EqualAssVarVar) {
	 				EqualAssVarVar t = (EqualAssVarVar) stack.pop();
	 				VariableNode v1 = t.e1;
	 				VariableNode v2 = t.e2;
	 				DivNode div = new DivNode(v2, new VariableNode(yytext()));
	 				stack.push(new EqualGeneral(v1, div));
	 			} else if (stack.peek() instanceof EqualGeneral) {
	 				EqualGeneral eq = (EqualGeneral) stack.pop();
	 				Expression o1 = eq.e1;
	 				Expression o2 = eq.e2;
	 				DivNode div = new DivNode(o2, new VariableNode(yytext()));
	 				stack.push(new EqualGeneral(o1, div));
	 			}		
			} else {stack.push(new VariableNode(yytext()));}
		} 
}

{semicolon}	{
	 flagInteger = 0;
	 if (stack.size() != 0 &&
	  		(stack.peek() instanceof IntNode ||
	  		 stack.peek() instanceof VariableNode ||
	  		 stack.peek() instanceof DivNode ||
	  		 stack.peek() instanceof BracketNode)) {
	 	Stack<Expression> plus = new Stack<>();
	 	while ( stack.size() != 0 &&
	 		  	(stack.peek() instanceof IntNode ||
	 		    (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("+")) ||
	 		    stack.peek() instanceof VariableNode ||
	 		    stack.peek() instanceof DivNode ||
	 		    stack.peek() instanceof BracketNode)) {
	 		if ((stack.peek() instanceof IntNode ||
	 			 stack.peek() instanceof VariableNode ||
	 			 stack.peek() instanceof DivNode ||
	 			 stack.peek() instanceof BracketNode)) {
	 			plus.push(stack.pop());
	 		} else {
	 			stack.pop();
	 		}
	 	}
	 	if (stack.peek() instanceof EqualAss) {
	 		EqualAss t = (EqualAss) stack.pop();
	 		VariableNode v = t.e1;
	 		IntNode n = t.e2;
	 		int result = Integer.parseInt(n.node());
	 		 
	 		if (plus.peek() instanceof IntNode) {
	 			IntNode a = (IntNode) plus.peek();
	 			result += Integer.parseInt(a.node());
	 		}
	 		if (plus.peek() instanceof VariableNode) {
	 			VariableNode a = (VariableNode) plus.peek();
	 			if (!intMap.containsKey(a.node()) || intMap.get(a.node()).equals("null")) {
	 				UnassignedVar = 1;
	 				line = yyline;
	 			} else {	 
	 				result += Integer.parseInt(intMap.get(a.node()));
	 			}
	 		}
	 		PlusNode p = new PlusNode(n, plus.pop());
	 		while (plus.size() != 0) { 		 
	 			if (plus.peek() instanceof IntNode) {
	 				IntNode a = (IntNode) plus.peek();
	 				result += Integer.parseInt(a.node());
	 			}
	 			if (plus.peek() instanceof VariableNode) {
	 				VariableNode a = (VariableNode) plus.peek();
	 				if (!intMap.containsKey(a.node()) || intMap.get(a.node()).equals("null")) {
	 					UnassignedVar = 1;
	 					line = yyline;
	 				} else {	 
	 					result += Integer.parseInt(intMap.get(a.node()));
	 				}
	 			}
	 			p = new PlusNode(p, plus.pop());
	 		}
	 		intMap.put(v.node(), Integer.toString(result));
	 		stack.push(new EqualGeneral(v, p));
	 	} else if (stack.peek() instanceof EqualAssVarVar) {
	 		EqualAssVarVar t = (EqualAssVarVar) stack.pop();
	 		VariableNode v1 = t.e1;
	 		VariableNode v2 = t.e2;
	 		
	 		int result = Integer.parseInt(intMap.get(v2.node()));
	 		 
	 		if (plus.peek() instanceof IntNode) {
	 			IntNode a = (IntNode) plus.peek();
	 			result += Integer.parseInt(a.node());
	 		}
	 		if (plus.peek() instanceof VariableNode) {
	 			VariableNode a = (VariableNode) plus.peek();
	 			if (!intMap.containsKey(a.node()) || intMap.get(a.node()).equals("null")) {
	 				UnassignedVar = 1;
	 				line = yyline;
	 			} else {	 
	 				result += Integer.parseInt(intMap.get(a.node()));
	 			}
	 		}
	 		
	 		PlusNode p = new PlusNode(v2, plus.pop());
	 		while (plus.size() != 0) {
	 			if (plus.peek() instanceof IntNode) {
	 				IntNode a = (IntNode) plus.peek();
	 				result += Integer.parseInt(a.node());
	 			}
	 			if (plus.peek() instanceof VariableNode) {
	 				VariableNode a = (VariableNode) plus.peek();
	 				if (!intMap.containsKey(a.node()) || intMap.get(a.node()).equals("null")) {
	 					UnassignedVar = 1;
	 					line = yyline;
	 				} else {	 
	 					result += Integer.parseInt(intMap.get(a.node()));
	 				}
	 			}
	 			p = new PlusNode(p, plus.pop());
	 		}
	 		intMap.put(v1.node(), Integer.toString(result));
	 		stack.push(new EqualGeneral(v1, p));
	 	} else if (stack.peek() instanceof EqualGeneral) {
	 		EqualGeneral t = (EqualGeneral) stack.pop();
	 		Expression e1 = t.e1;
	 		Expression e2 = t.e2;
	 		 
	 		PlusNode p = new PlusNode(e2, plus.pop());
	 		while (plus.size() != 0) {
	 			p = new PlusNode(p, plus.pop());
	 		}
	 		stack.push(new EqualGeneral(e1, p));
	 	} else if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("=")) {
	 		stack.pop();
	 		Expression e1 = plus.pop();
	 		if (plus.size()!=0) {
	 			PlusNode p = new PlusNode(e1, plus.pop()); 
	 			while(plus.size()!=0) {
	 				p = new PlusNode(p, plus.pop());
	 			}
	 			stack.push(new EqualGeneral(stack.pop(), p));
	 		} else {
	 			stack.push(new EqualGeneral(stack.pop(), e1));
	 		}
	 	}
	 }
}

{closed} {
	int greaterFlag = 0;
	int andFlag = 0;
	Stack<Expression> s = new Stack<>();
	while (stack.size() != 0 ) {
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("(")) {
			stack.pop();
			break;
		}
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals(">")) {
			stack.pop();
			greaterFlag = 1;
			break;
		}
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("+")) {
			stack.pop();
		} else if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("&&")) {
			stack.pop();
			andFlag = 1;
		} else
			s.push(stack.pop());
	}
	
	if (andFlag == 1) {
		AndNode node = new AndNode(s.pop(), s.pop());
		while(s.size()!=0) {
			node = new AndNode(node, s.pop());
		}
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("!")) {
			stack.push(new NotNode(new BracketNode(node)));
		} else
			stack.push(new BracketNode(node));
	} else if (greaterFlag == 1) {
		Expression e1 = stack.pop();
		Expression checkhere = stack.pop();
		GreaterNode greater;
		if (s.size() >= 2) { 
			PlusNode p = new PlusNode(s.pop(), s.pop());
			while(s.size()!=0) {
				p = new PlusNode(p, s.pop());
			}
			greater = new GreaterNode(e1, p);
		} else {	
			greater = new GreaterNode(e1, s.pop());
		}
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("!")) {
			stack.pop();
			stack.push(new NotNode(new BracketNode(greater)));
		} else if (((Symbol)(checkhere)).symbol().equals("&&")) {
			stack.push(checkhere);
			stack.push(greater);
			Stack<Expression> store = new Stack<>();
			while (stack.size() != 0) {
				if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("(")) {
					stack.pop();
					break;
				}
				if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("&&"))
					stack.pop();
				else
					store.push(stack.pop());
			}
			AndNode p = new AndNode(store.pop(), store.pop());
			while(store.size()!=0) {
				p = new AndNode(p, store.pop());
			}
			stack.push(new BracketNode(p));
		} else {
			stack.push(new BracketNode(greater));
		}
	} else {
		if (s.size() >= 2) {
			PlusNode p = new PlusNode(s.pop(), s.pop());
			while(s.size()!=0) {
				p = new PlusNode(p, s.pop());
			}
			if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("!")) {
				stack.pop();
				stack.push(new NotNode(new BracketNode(p)));
			} else {
				stack.push(new BracketNode(p));
			}
		} else {
			if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("!")) {
				stack.pop();
				stack.push(new NotNode(new BracketNode(s.pop())));
			} else {
				stack.push(new BracketNode(s.pop()));
			}
		}
		Expression e1 = stack.pop();
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("/")) {
			stack.pop();
			Expression e2 = stack.pop();
			stack.push(new DivNode(e2, e1));
		} else {
			stack.push(e1);
		}
	}
}

{closeb} {
	if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("{")) {
		stack.pop();
		stack.push(new BlockNode(null));
	} else {
		LinkedList<Expression> list = new LinkedList<>();
		while (stack.size() != 0) {
			if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("{")) {
				stack.pop();
				break;
			}
			list.add(stack.pop());
		}
		Collections.reverse(list);
		if (list.size() == 1) {
			stack.push(new BlockNode(list.pollLast()));	
		} else {
			Expression e1 = list.pollLast();
			Expression e2 = list.pollLast();
			SequenceNode s = new SequenceNode(e2, e1);
			while (list.size() != 0) {
				s = new SequenceNode(list.pollLast(), s);
			}
			stack.push(new BlockNode(s));
		}
	}
	Expression b1 = stack.pop();
	if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("else")) {
		stack.pop();
		Expression b2 = stack.pop();
		Expression cond = stack.pop();
		stack.pop();
		Expression ifcond = new IfNode(cond, b2, b1);
		stack.push(ifcond);
	} else {
		Expression cond = stack.pop();
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("while")) {
			stack.pop();
			stack.push(new WhileNode(cond, b1));
		} else {
			stack.push(cond);
			stack.push(b1);
		}
	}
}

{greater}	{
	Stack<Expression> s = new Stack<>();
	while (stack.size() != 0) {
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("("))
			break;
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("&&"))
			break;	
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("+"))
			stack.pop();
		else
			s.push(stack.pop());
	}
	
	Expression e1 = s.pop();
	if (s.size()!=0) {
		PlusNode p = new PlusNode(e1, s.pop());
		while(s.size()!=0) {
			p = new PlusNode(p, s.pop());
	 	}
		stack.push(p);
	} else {
	 	stack.push(e1);
	}
	stack.push(new Symbol(">"));
}

{andnode} {
	Stack<Expression> s = new Stack<>();
	int parFlag = 0;
	int greaterFlag = 0;
	while (stack.size() != 0) {
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals(">")) {
			stack.pop();
			greaterFlag = 1;
			break;
		}
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("(")) {
			parFlag = 1;
			break;
		}
		if (stack.peek() instanceof Symbol && ((Symbol) (stack.peek())).symbol().equals("+")) {
			stack.pop();
		} else {
			s.push(stack.pop());
		}
	}
	if (parFlag == 1) {
		stack.push(s.pop());
		stack.push(new Symbol("&&"));
	} else if (greaterFlag == 1) {
		if (s.size() >= 2) {
			PlusNode p = new PlusNode(s.pop(), s.pop());
			while (s.size() != 0) {
				p = new PlusNode(p, s.pop());
			}
			stack.push(new GreaterNode(stack.pop(), p));
		} else {
			stack.push(new GreaterNode(stack.pop(), s.pop()));
		}
	}
	stack.push(new Symbol("&&"));
}
{colon}	{}
\n 	{}
.	{}



