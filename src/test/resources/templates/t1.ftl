p1

<#if 5>
    p2
</#if>

p3
${x1}p3-1

<#if "hello1${v}xx">
p4

<#else>
</#if>

p5

<#if 'hello2${v}xx'>p6</#if>p7

${built1?built2?built3}

<#assign valAssign = 5 + 6 * (7 - 8) / 4>

${"green " + "mouse"?upper_case}    <#-- green MOUSE -->
<#if !(color == "red" || color == "green")>
  The color is nor red nor green${x}
  hell
    ${y}
</#if>


${5 - -3}
${x+":"+book.title?upper_case}
${x+":"+v1.v2()?upper_case}
${f(5, 5+5)}

${1 && 2 || 3 && 4}

<#assign myHash = { }>
<#assign myHash = { "name": "mouse"}>
<#assign myHash = { "name": "mouse", "price": 50 }>
<#assign myHash = { "name": "mouse", "price": 50, "other": 3 }>
<#assign myHash = { "name": "mouse", "price": 50, "other": {"a":  5} }>