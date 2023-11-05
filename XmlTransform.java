import javax.xml.transform.*;
import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayOutputStream;
import java.io.File;

public class XmlTransform {
    public static void main(String[] args) throws TransformerException {
        Source xslt = new StreamSource(new File(args[0]));
        Source xml = new StreamSource(new File(args[1]));
        StreamResult out = new StreamResult(new ByteArrayOutputStream());

        TransformerFactory factory = TransformerFactory.newInstance();
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");

        Transformer transformer = factory.newTransformer(xslt);
        transformer.transform(xml, out);
        System.out.println(out.getOutputStream().toString());
    }
}
