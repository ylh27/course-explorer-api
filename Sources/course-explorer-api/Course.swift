import Foundation

// traverse the course level
// function will retreive a list of section id in the course
// each section is added to the list
public func traverseCourse(urlPrefix: String, completion: @escaping ([CourseSection]?) -> Void) {
    let url = URL(string: urlPrefix + ".xml")!
    let courseParser = IdParser(parentTag: "sections", childTag: "section")
    
    var SectionList: [CourseSection] = []
    
    courseParser.parseURL(url: url) { list in
        print("traversing list")
        if list == nil {
            print("parsing '" + urlPrefix + ".xml' unsucessful")
            completion(nil)
        }
        for section in list! {
            print("parsing " + urlPrefix + "/" + section + ".xml")
            //let section_url = URL(string: urlPrefix + "/" + section + ".xml")!
            let sectionParser = SectionParser()
            
            sectionParser.parseURL(urlPrefix: urlPrefix, SectionID: section) { section in
                SectionList.append(section!)
                print(section!.sectionNumber! + " parsed")
                print(String(SectionList.count) + "/" + String(list!.count) + " Sections")
                if SectionList.count == list!.count {
                    completion(SectionList)
                }
            }
        }
    }
}

/*class CourseParser {
    // parse from xml
    func parseXML(data: Data) -> [String]? {
        let parser = XMLParser(data: data)
        let delegate = CourseParserDelegate()
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
            let delegate = CourseParserDelegate()
        
            // Set the delegate for the parser
            parser.delegate = delegate
        
            // Start parsing
            if parser.parse() {
                print("Parsing successful")
                completion(delegate.list)
            } else {
                print("Parsing failed")
                completion(nil)
            }
        }
    
    // Resume the task to initiate the data fetching
    task.resume()
    }
}

class CourseParserDelegate: NSObject, XMLParserDelegate {
    var currentElement: String = ""
    var currentValue: String = ""
    var list: [String]?
    
    // Called when the parser starts parsing the document
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Parsing started")
    }
    
    // Called when the parser finishes parsing the document
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parsing ended")
    }
    
    // Called for each opening tag in the XML
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "sections" {
            list = []
        } else if elementName == "section" {
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
}*/

