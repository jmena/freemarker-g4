package me.bgx.freemarker;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import org.apache.commons.io.IOUtils;
import org.junit.Test;

public class FmParserTest {

    @Test
    public void simple_template() {
        final FmParser parser = new FmParser();
        parser.parse("<b>Hello world!</b>", "simpleTemplate");
    }

    @Test(expected = FmParser.SyntaxError.class)
    public void invalid_template() {
        final FmParser parser = new FmParser();
        parser.parse("${ something", "simpleTemplate");
    }

    @Test
    public void all_templates() throws IOException {

        final String templates = readTemplate("");

        for (final String fileName : templates.split("\n")) {
            System.out.println("---------------------------------------------------");
            System.out.println("Parsing: '" + fileName + "'");
            final String template = readTemplate(fileName);
            System.out.println(template);

            // parse
            final FmParser parser = new FmParser();
            String tree = parser.parse(template, fileName);

            // output
            System.out.println("------");
            System.out.println(tree);
            System.out.println();
        }
    }

    private String readTemplate(final String resource) throws IOException {
        final InputStream is = getClass().getResourceAsStream("/templates/" + resource);
        return IOUtils.toString(is, StandardCharsets.UTF_8);
    }
}