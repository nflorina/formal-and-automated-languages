build: hello types helloLexer parser

hello:
	jflex Hello.flex

types:
	javac types.java
	
helloLexer:
	javac HelloLexer.java

parser:
	javac Parser.java

run:
	java Parser input

clean:
	rm *.class 
