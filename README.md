# Okm2SFDC
This code will be used to convert the Oracle Knowledge Management Articles  XML data to CSV (HTML + Images) which can be used to import into salesforce using article import tool

- Cretaed an XSLT to read the XML content.
- Use JAVA code to covert XML to csv based on XSLT
- Richtext values in XML will be converted to HTML and refrenced back in csv
- Folder Structure from Source
      - XML FILE
      - Embedded folder with Images (Folder name should be FAQ Number)
- Handles the base64 Decodeded images in XML.      
