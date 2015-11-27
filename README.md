# XenServer XSLT Template

An XSLT Stylesheet for interpreting the XenServer XAPI Database.

Originally based on my work at Citrix in 2010 (http://support.citrix.com/article/CTX129070), this repository contains amendments to reflect changes in how XAPI stores data. This version is designed to work with XenServer 6.5, but may work with earlier and later releases with varying degrees of success.

To use this XSLT:

1. Get a current XAPI Database XML database. This can be done from within XenCenter by exporting a Server Status Report (Tools -> Server Status Report in XenCenter) with the "XenServer Database" option selected.

2. Open the ZIP file containing the report and copy the **xapi-db.xml** file to the same location as the xslt file.

3. Open the xapi-db.xml file and place the following at the very top:
`<?xml-stylesheet type="text/xsl" href="xenserver.xsl"?>`

4. Open the **xapi-db.xml** file in a web browser that can apply XSLT templates to an XML document such as Firefox or Internet Explorer (does not work in Chrome).
