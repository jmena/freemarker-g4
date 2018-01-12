package me.bgx.freemarker;

public class FreemarkerListener extends FreemarkerParserBaseListener {
    @Override
    public void enterTemplate(FreemarkerParser.TemplateContext ctx) {
        System.out.println("in enter template");
    }

    @Override
    public void enterIfDirective(final FreemarkerParser.IfDirectiveContext ctx) {
        System.out.println("if expr: " + ctx.tagExpr().expr().getText());
    }
}
