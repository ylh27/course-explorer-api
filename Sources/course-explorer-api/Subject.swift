import Foundation


// traverse the subject level
// function will retreive use SubjectParser to retreive a list of course id in the subject
// then course level traversal is called for every course in the list
public func traverseSubject(urlPrefix: String, completion: @escaping ([CourseSection]?) -> Void) {
    let url = URL(string: urlPrefix + ".xml")!
    let subjectParser = IdParser(parentTag: "courses", childTag: "course")
    
    subjectParser.parseURL(url: url) { list in
        if list == nil {
            print("parsing '" + urlPrefix + ".xml' unsucessful")
            completion(nil)
        }
        var count = 0
        var returnList: [CourseSection] = []
        for course in list! {
            traverseCourse(urlPrefix: urlPrefix+"/"+course) { SectionList in
                returnList += SectionList!
                count += 1
                print(String(count) + "/" + String(list!.count) + " Courses")
                if count == list!.count {
                    completion(returnList)
                }
            }
        }
    }
}

/*class SubjectParser {
    // parse from xml
    func parseXML(data: Data) -> [String]? {
        let parser = XMLParser(data: data)
        //let delegate = SubjectParserDelegate()
        let delegate = IdParserDelegate(parentTag: "courses", childTag: "course")
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
            let delegate = SubjectParserDelegate()
        
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

class SubjectParserDelegate: NSObject, XMLParserDelegate {
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
        if elementName == "courses" {
            list = []
        } else if elementName == "course" {
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
