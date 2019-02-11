import java.util.ArrayList;

abstract interface Expression {
	String show();
	Expression interpret();
};

class EmptyList implements Expression {
	@Override
	public String show() {
		return "EmptyList\n";
	}

	@Override
	public Expression interpret() {
		return this;
	}
	
}
/////////////////////////////////////////////////////////////////
class ExprList implements Expression {
	ArrayList<Expression> elems;

	public ExprList(ArrayList<Expression> elems) {
		super();
		this.elems = elems;
	}

	@Override
	public String show() {
		String build = "";
		build += "<MainNode>\n";
		
		String print = "";
		for (Expression e : elems) {
				print += e.show();
		}
		
		build += Parser.addNewline(print); 
		
		return build;
	}

	@Override
	public Expression interpret() {
		// interpretez toate elementele listei, pentru a avea o lista de liste
		ArrayList<Expression> newls = new ArrayList<Expression>();
		for (Expression e : elems) {
			newls.add(e.interpret());
		}
		return new ExprList(newls);
	}
};
//////////////////////////////////////////////////////
class Symbol implements Expression {
	String symbol;

	public Symbol(String symbol) {
		super();
		this.symbol = symbol;
	}
	
	String symbol() {
		return symbol;
	}

	@Override
	public String show() {
		return symbol;
	}

	@Override
	public Expression interpret() {
		return null;
	}
	
};
//////////////////////////////////////////////////
class EqualAss implements Expression {
	VariableNode e1;
	IntNode e2;

	public EqualAss(VariableNode e1,IntNode e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<AssignmentNode> =\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		
		return new ExprList(el);
	} 
	
};
////////////////////////////////////////////
class IntNode implements Expression {
	String node;

	public IntNode(String node) {
		super();
		this.node = node;
	}
	
	String node() {
		return node;
	}

	@Override
	public String show() {
		return "<IntNode> " + node + "\n";
	}

	@Override
	public Expression interpret() {
		return null;
	}
};

////////////////////////////////////////////
class VariableNode implements Expression {
	String node;

	public VariableNode(String node) {
		super();
		this.node = node;
	}

	String node() {
		return node;
	}

	@Override
	public String show() {
		return "<VariableNode> " + node + "\n";
	}

	@Override
	public Expression interpret() {
		return null;
	}
};
//////////////////////////////////////////////////////////////
class SequenceNode implements Expression {
	Expression e1;
	Expression e2;

	public SequenceNode(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}

	@Override
	public String show() {
		String build = "";
		build += "<SequenceNode>\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		
		return new ExprList(el);
	} 
};
////////////////////////////////////////////////////////////////
class EqualAssVarVar implements Expression {
	VariableNode e1;
	VariableNode e2;

	public EqualAssVarVar(VariableNode e1, VariableNode e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<AssignmentNode> =\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		
		return new ExprList(el);
	} 
	
};

/////////////////////////////////////////////

class EqualGeneral implements Expression {
	Expression e1;
	Expression e2;

	public EqualGeneral(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<AssignmentNode> =\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		
		return new ExprList(el);
	} 
	
};
///////////////////////////////////////////////////////////////

class PlusNode implements Expression {
	Expression e1;
	Expression e2;

	public PlusNode(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<PlusNode> +\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		
		return new ExprList(el);
	} 
	
};
////////////////////////////////////////////////////////
class DivNode implements Expression {
	Expression e1;
	Expression e2;

	public DivNode(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<DivNode> /" + "\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		return new ExprList(el);
	} 
	
};
///////////////////////////////////////////////////////////

class BracketNode implements Expression {
	Expression e1;

	public BracketNode(Expression e1) {
		super();
		this.e1 = e1;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<BracketNode> ()" + "\n";
		
		String print = "";
		print += e1.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ArrayList<Expression> el = ea.elems;
		return new ExprList(el);
	} 
	
};
//"<BlockNode> {}////////////////////////////////////////////
class BlockNode implements Expression {
	Expression e1;

	public BlockNode(Expression e1) {
		super();
		this.e1 = e1;
	}
	
	@Override
	public String show() {
		
		String build = "";
		build += "<BlockNode> {}" + "\n";
		
		String print = "";
		if (e1 != null) { 
			print += e1.show();
		}
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ArrayList<Expression> el = ea.elems;
		return new ExprList(el);
	} 
	
};
//<IfNode> if///////////////////////////////////////////////////////////
class IfNode implements Expression {
	Expression condition;
	Expression body_;
	Expression else_;

	public IfNode(Expression condition, Expression body_, Expression else_) {
		super();
		this.condition = condition;
		this.body_ = body_;
		this.else_ = else_;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<IfNode> if" + "\n";
		String print = "";
		print += condition.show() + body_.show() + else_.show();
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) condition.interpret();
		ExprList eb = (ExprList) body_.interpret();
		ExprList ec = (ExprList) else_.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(eb.elems);
		el.addAll(ec.elems);
		return new ExprList(el);
	} 
	
};
////////////<BoolNode> True/////////////////
class BoolNode implements Expression {
	String node;
	Boolean val;

	public BoolNode(String node, Boolean val) {
		super();
		this.node = node;
		this.val = val;
	}
	
	String node() {
		return node;
	}
	
	@Override
	public String show() {
		return "<BoolNode> " + node + "\n";
	}
	
	@Override
	public Expression interpret() {
		return null;
	}
};
/////////////<GreaterNode> >...
class GreaterNode implements Expression {
	Expression e1;
	Expression e2;

	public GreaterNode(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<GreaterNode> >" + "\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		return new ExprList(el);
	} 
	
};
///<NotNode> !"...................

class NotNode implements Expression {
	Expression e1;

	public NotNode(Expression e1) {
		super();
		this.e1 = e1;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<NotNode> !" + "\n";
		
		String print = "";
		print += e1.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ArrayList<Expression> el = ea.elems;
		return new ExprList(el);
	} 
	
};
////////////////////////////<AndNode> &&
class AndNode implements Expression {
	Expression e1;
	Expression e2;

	public AndNode(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<AndNode> &&" + "\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) e1.interpret();
		ExprList ec = (ExprList) e2.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(ec.elems);
		return new ExprList(el);
	} 
	
};
/////////<WhileNode> while/////////////
class WhileNode implements Expression {
	Expression condition;
	Expression body;

	public WhileNode(Expression condition, Expression body) {
		super();
		this.condition = condition;
		this.body = body;
	}
	
	@Override
	public String show() {
		String build = "";
		build += "<WhileNode> while" + "\n";
		String print = "";
		print += condition.show() + body.show();
		build += Parser.addNewline(print); 
		return build;
	}
	@Override
	public Expression interpret() {
		// interpretez cele doua expresii din interior pentru a obtine liste
		ExprList ea = (ExprList) condition.interpret();
		ExprList eb = (ExprList) body.interpret();
		ArrayList<Expression> el = ea.elems;
		el.addAll(eb.elems);
		return new ExprList(el);
	} 
	
};
