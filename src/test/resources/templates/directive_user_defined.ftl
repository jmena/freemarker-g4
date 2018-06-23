<#macro do_thrice1 p1>
    ${p1} <#nested 1>
    ${p1} <#nested 2>
    ${p1} <#nested 3>
</#macro>
<@do_thrice1 "7"; x> ${x} Anything. </@do_thrice1>

<#macro do_thrice>
    <#nested 1>
    <#nested 2>
    <#nested 3>
</#macro>
<@do_thrice ; x> <#-- user-defined directive uses ";" instead of "as" -->
    ${x} Anything.
</@do_thrice>

<@something />

<@somethig x=5  />

<@something x=5 ; a, b>
</@something>

<@something 5, 7, 8>
</@something>

<@something 5 7 8>
</@something>

<@a.b.c 5 7 8 />
