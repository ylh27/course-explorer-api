import Foundation

class IdParser {
    var parentTag: String = ""
    var childTag: String = ""
    
    init(parentTag: String, childTag: String) {
        self.parentTag = parentTag
        self.childTag = childTag
    }
    
    // parse from xml
    func parseXML(data: Data) -> [String]? {
        let parser = XMLParser(data: data)
        let delegate = IdParserDelegate(parentTag: self.parentTag, childTag: self.childTag)
        parser.delegate = delegate
        
        if parser.parse() {
            return delegate.list
        } else {
            return nil
        }
    }
    
    // parse from url
    func parseURL(url: URL, completion: @escaping ([String]?) -> Void) {
        // Create a URLSession task to fetch the XML data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching XML data:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            // Create an XMLParser instance
            let parser = XMLParser(data: data)
        
            // Create a delegate object
            let delegate = IdParserDelegate(parentTag: self.parentTag, childTag: self.childTag)
        
            // Set the delegate for the parser
            parser.delegate = delegate
        
            // Start parsing
            if parser.parse() {
                print("ID Parsing successful")
                completion(delegate.list)
            } else {
                print("ID Parsing failed")
                completion(nil)
            }
        }
    
    // Resume the task to initiate the data fetching
    task.resume()
    }
}

class IdParserDelegate: NSObject, XMLParserDelegate {
    var parentTag: String = ""
    var childTag: String = ""
    
    init(parentTag: String, childTag: String) {
        self.parentTag = parentTag
        self.childTag = childTag
    }
    
    var currentElement: String = ""
    var currentValue: String = ""
    var list: [String]?
    
    // Called when the parser starts parsing the document
    func parserDidStartDocument(_ parser: XMLParser) {
        print("ID Parsing started")
    }
    
    // Called when the parser finishes parsing the document
    func parserDidEndDocument(_ parser: XMLParser) {
        print("ID Parsing ended")
    }
    
    // Called for each opening tag in the XML
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == parentTag {
            list = []
        } else if elementName == childTag {
            if let id = attributeDict["id"] {
                list!.append(id)
            }
        }
    }
    
    // Called for each closing tag in the XML
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentValue = ""
    }
    
    // Called for the content of each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }
}
