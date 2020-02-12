import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.bind.DatatypeConverter;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class convertXMLToOCSVandHTML {
	
	public void ConvertXMLTOCSV_HTML(String XMLFileName, String XSLFileName,
			String CSVCreatingPath, String HTMLFolderName) {
		try {
			DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = domFactory.newDocumentBuilder();
			Document dDoc = builder.parse(XMLFileName);

			// normalize text representation
			dDoc.getDocumentElement().normalize();
			String HTMLCreationPath = CSVCreatingPath+HTMLFolderName+"\\";
			convertXMLToCSV(dDoc, XSLFileName, CSVCreatingPath,HTMLCreationPath,HTMLFolderName);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// Creating the CSV file
	public void convertXMLToCSV(Document document, String XSLFileName,String CSVCreatingPath,String HTMLCreationPath,String HTMLFolderName) {
		String FileName = null;
		try {
			FileName = "ITBJapan" + getCurrentDateTimeStamp() + ".csv";
			File stylesheet = new File(XSLFileName);

			StreamSource stylesource = new StreamSource(stylesheet);
			Transformer transformer = TransformerFactory.newInstance().newTransformer(stylesource);
			transformer.setParameter("HTMLPATH", HTMLCreationPath);
			transformer.setParameter("HTMLFOLDERNAME", HTMLFolderName+"/");
			Source source = new DOMSource(document);
			Result outputTarget = new StreamResult(new File(CSVCreatingPath
					+ FileName));
			transformer.transform(source, outputTarget);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static synchronized String createFile(String fileNamePrefix,
			String fileContent, String filePath) throws Exception {
		String FileName = null;
		Writer writer = null;
		try {
			FileName = fileNamePrefix + "-" + getCurrentDateTimeStamp() + ".html";
			//FileName = fileNamePrefix +".html";
			writer = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(filePath + "\\" + FileName), "UTF-8"));
			writer.write(fileContent);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			writer.close();
		}
		return FileName;
	}

	public static String getCurrentDateTimeStamp() {
		String curTime = null;
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyy");
			curTime = sdf.format(new Date());
			//curTime = curTime + System.currentTimeMillis();
			  curTime = curTime + System.nanoTime(); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return curTime;
	}
	//Normal Method
	/*public static String convertXMLToHTMLFile(String fileNamePrefix,String fileContent,String HTMLCreationPath)
	{
		String HTMLFileName = null;
		try {
			HTMLFileName = createFile(fileNamePrefix, fileContent, HTMLCreationPath);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return HTMLFileName;
	}*/
	
	//Method to automatically format file path
	/*public static String convertXMLToHTMLFile(String fileNamePrefix,String fileContent,String HTMLCreationPath)
    {
          String HTMLFileName = null;
          String PartialSeachPattern = "src=\"/";
          try 
          {
                if(fileContent.contains(PartialSeachPattern))
                {
                      String regex = "src=\"/*[a-zA-Z0-9/_.]*";
                      Pattern p = Pattern.compile(regex);   // the pattern to search for
                    Matcher m = p.matcher(fileContent);
                    
                    String ReplaceString = "src=\"faq/"+fileNamePrefix+"/";
                    // now try to find at least one match
                    while (m.find())
                    {
                      String findSting  = m.group();
                      String[] Split = findSting.split("/");
                      fileContent = fileContent.replaceAll(m.group(), ReplaceString+Split[Split.length-1]);                       
                    }
                      HTMLFileName = createFile(fileNamePrefix, fileContent, HTMLCreationPath);
                }
                else
                {
                      HTMLFileName = createFile(fileNamePrefix, fileContent, HTMLCreationPath);
                }
          } catch (Exception e) {
                e.printStackTrace();
          }
          return HTMLFileName;
    }*/
	
	// change base 64 to image
	
	
	public static String convertXMLToHTMLFile(String fileNamePrefix,String fileContent,String HTMLCreationPath)
	{
		String HTMLFileName = null;
		String PartialSeachPattern = "src=\"";
		int imageCount = 0;
		try 
		{
			if(fileContent.contains(PartialSeachPattern))
			{
				//This is for base64 decode data to image file
				String regex = "src=\"data:image\\/([a-zA-Z]*);base64,([^\"]*)\"";
				Pattern p = Pattern.compile(regex);   // the pattern to search for
				Matcher m = p.matcher(fileContent);
				    
				String ReplaceString = "src=\"faq/"+fileNamePrefix+"/";
				// now try to find at least one match
				while (m.find())
				{
					String[] splitStrings = m.group().split(",");
					String extension;
				    if(splitStrings[0].contains("jpeg"))
				    	extension = "jpeg";
				    else if(splitStrings[0].contains("png"))
				    	extension = "png";
				    else if(splitStrings[0].contains("gif"))
				    	extension = "gif";
				    else
				    	extension = "jpg";
				  
				    //convert base64 string to binary data
				    byte[] data = DatatypeConverter.parseBase64Binary(splitStrings[1]);
			        new File(HTMLCreationPath+"faq\\"+fileNamePrefix).mkdir();//New Folder creation
			        String path = HTMLCreationPath+"faq\\"+fileNamePrefix+"\\image"+imageCount+"." + extension;
			        File file = new File(path);
			        try 
			        {
				        OutputStream os = new FileOutputStream(file); 
				       	os.write(data);
				       	os.close();
				    } 
				    catch (IOException e) 
				    {
				         e.printStackTrace();
				    }
				    fileContent = fileContent.replace(m.group(), ReplaceString+"image"+imageCount+"." + extension+"\"");	
				    imageCount++;
				}
				//This is for converting long folder path to shorted path
				//This regex will check all matching file paths-all possible 
				//String regex1 = "src=\"/*[a-zA-Z0-9/_.]*";
				//String regex1 = "src=\"/*[^\\\\https file][a-zA-Z0-9/_.]*";
				String regex1 = "src=\"/*[^\\\\https file][a-zA-Z0-9/_\\-%20.]*";
				
				Pattern p1 = Pattern.compile(regex1);   // the pattern to search for
			    Matcher m1 = p1.matcher(fileContent);
			    
			    //String ReplaceString1 = "src=\"/"+fileNamePrefix+"/";
			    String ReplaceString1 = "src=\"faq/"+fileNamePrefix+"/";
			    // now try to find at least one match
			    while (m1.find())
			    {
			    	String findSting  = m1.group();
			    	if(!findSting.contains("faq"))
			    	{
				    	String[] Split = findSting.split("/");
				    	fileContent = fileContent.replace(m1.group(), ReplaceString1+Split[Split.length-1]);
			    	}
			    }
			}
		    HTMLFileName = createFile(fileNamePrefix, fileContent, HTMLCreationPath);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return HTMLFileName;
	}
	

	
	public static void main(String[] args) {
		convertXMLToOCSVandHTML oObject = new convertXMLToOCSVandHTML();
		oObject.ConvertXMLTOCSV_HTML(
				"C:\\Users\\sesa331364\\Desktop\\OutputcKM-FAQ-APS_GLOBAL.xml",
				"C:\\Users\\sesa331364\\Desktop\\CKM Migration\\XSLT\\styleFAQ.xsl",
				"C:\\Users\\SESA331364\\Desktop\\ConvertXMLtoCSV\\CSVFiles\\",
				"HTMLFiles");
	}
}
