import java.io.*;
import java.util.*;

public class Parser {
	public static String addNewline(String print) {
		Scanner scanner = new Scanner(print);
		String build = "";
		while (scanner.hasNextLine()) {
			String line = scanner.nextLine();
			build += "	" + line + "\n";
		}
		scanner.close();
		return build;
	}
	
	public static void main (String[] args) throws IOException {
		HelloLexer l = new HelloLexer(new FileReader(args[0]));
		l.yylex();
		String str = ((ExprList)l.stack.pop()).show();
		String out = "";
		if (l.UnassignedVar == 1) {
			out += "UnassignedVar";
			int line = l.line + 1;
			out += " " + (String.valueOf(line));
		} else {
			for (Map.Entry<String, String> pair : l.intMap.entrySet()) {
				out += pair.getKey() + "=" + pair.getValue() + "\n";
			}
		}

		try {
			File file1 = new File("output");
			FileWriter fileWriter1 = new FileWriter(file1);
			fileWriter1.write(out);
			fileWriter1.flush();
			fileWriter1.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		try {
			File file = new File("arbore");
			FileWriter fileWriter = new FileWriter(file);
			fileWriter.write(str);
			fileWriter.flush();
			fileWriter.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}
