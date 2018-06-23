package me.bgx.freemarker;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CodePointCharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.atn.ATNConfigSet;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.tree.Trees;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

public class FmParser {

    @AllArgsConstructor
    @Getter
    @ToString
    public static class SyntaxError extends RuntimeException {
        Recognizer<?, ?> recognizer;
        Object offendingSymbol;
        int line;
        int charPositionInLine;
        String msg;
        RecognitionException e;

    }

    public static class ReportContextSensitivity extends RuntimeException {
    }

    public static class ErrorListener extends BaseErrorListener {
        @Override
        public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            throw new SyntaxError(recognizer, offendingSymbol, line, charPositionInLine, msg, e);
        }

        @Override
        public void reportContextSensitivity(Parser recognizer, DFA dfa, int startIndex, int stopIndex, int prediction, ATNConfigSet configs) {
            // throw new ReportContextSensitivity();
        }
    }

    public String parse(final String text, String name) {

        final ErrorListener errorListener = new ErrorListener();

        final CodePointCharStream input = CharStreams.fromString(text, name);

        final FreemarkerLexer lexer = new FreemarkerLexer(input);
        lexer.removeErrorListeners();
        lexer.addErrorListener(errorListener);

        final CommonTokenStream tokens = new CommonTokenStream(lexer);

        final FreemarkerParser parser = new FreemarkerParser(tokens);
        parser.removeErrorListeners();
        parser.addErrorListener(errorListener);

        final FreemarkerParser.TemplateContext tree = parser.template(); // begin parsing at init rule

        return Trees.toStringTree(tree, parser);
//        final FreemarkerListener listener = new FreemarkerListener();
//        ParseTreeWalker.DEFAULT.walk(listener, tree);

//        return tree;

    }
}
