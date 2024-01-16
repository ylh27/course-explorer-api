import Foundation

public struct Course: Identifiable, Codable, Equatable {
    public var id: String = ""
    public var subject: String = ""
    public var subjectID: String = ""
    public var course: String = ""
    public var courseID: String = ""
    public var description: String = ""
    public var creditHours: String = ""
    public var prereq: [String] = []    // todo
    public var sections: [CourseSection] = []
}

class CourseParser {
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
    func parseURL(urlPrefix: String, course: String, completion: @escaping (Course?) -> Void) {
        // Create a URLSession task to fetch the XML data
        let task = URLSession.shared.dataTask(with: URL(string: urlPrefix+"/"+course+".xml")!) { (data, response, error) in
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
                var returnCourse = delegate.currentCourse
                returnCourse.courseID = course
                for sectionID in delegate.list {
                    let sectionParser = SectionParser()
                    sectionParser.parseURL(urlPrefix: urlPrefix+"/"+course, SectionID: sectionID) { section in
                        returnCourse.sections.append(section!)
                        if delegate.list.count == returnCourse.sections.count {
                            completion(returnCourse)
                        }
                    }
                }
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
    var list: [String] = []
    var currentCourse: Course = Course()
    var courseSectionInformation: String = ""
    
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
                list.append(id)
            }
        }
        
        else if elementName == "ns2:course" {
            if let id = attributeDict["id"] {
                currentCourse.id = id
            }
        } else if elementName == "subject" {
            if let id = attributeDict["id"] {
                currentCourse.subjectID = id
            }
        }
    }
    
    // Called for each closing tag in the XML
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if currentElement == elementName {
            if elementName == "subject" {
                currentCourse.subject = currentValue
            } else if elementName == "label" {
                currentCourse.course = currentValue
            } else if elementName == "description" {
                currentCourse.description = currentValue
            } else if elementName == "creditHours" {
                currentCourse.creditHours = currentValue
            } else if elementName == "courseSectionInformation" {
                courseSectionInformation = currentValue
            }
        }
        currentValue = ""
    }
    
    // Called for the content of each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }
}

