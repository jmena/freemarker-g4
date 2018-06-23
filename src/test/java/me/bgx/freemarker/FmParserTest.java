package me.bgx.freemarker;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestFactory;

public class FmParserTest {

    @Test
    public void simple_template() {
        final FmParser parser = new FmParser();
        parser.parse("<b>Hello world!</b>", "simpleTemplate");
    }

    @Test
    public void invalid_template() {
        Assertions.assertThrows(FmParser.SyntaxError.class, () -> {
            final FmParser parser = new FmParser();
            parser.parse("${ something", "simpleTemplate");
        });
    }

    @TestFactory
    public List<DynamicTest> all_templates() throws IOException {
        final String templates = readTemplate("");

        List<DynamicTest> lstTests = new ArrayList<>();

        for (final String fileName : templates.split("\n")) {
            lstTests.add(DynamicTest.dynamicTest(fileName, () -> {
                System.out.println("---------------------------------------------------");
                System.out.println("Parsing: '" + fileName + "'");
                final String template = readTemplate(fileName);
                System.out.println(template);

                // parse
                final FmParser parser = new FmParser();
                String tree = parser.parse(template, fileName);

                // output
                System.out.println("------ tree ------");
                System.out.println(tree);
                System.out.println();
            }));
        }

        return lstTests;
    }

    private String readTemplate(final String resource) throws IOException {
        final InputStream is = getClass().getResourceAsStream("/templates/" + resource);
        return IOUtils.toString(is, StandardCharsets.UTF_8);
    }
}