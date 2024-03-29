import Foundation

public struct CourseSection: Identifiable, Codable, Equatable {
    public var id: String = ""
    public var subject: String = ""
    public var subjectID: String = ""
    public var course: String = ""
    public var courseID: String = ""
    public var sectionNumber: String = ""
    public var statusCode: String = ""
    public var partOfTerm: String = ""
    public var sectionStatusCode: String = ""
    public var enrollmentStatus: String = ""
    public var startDate: String = ""
    public var endDate: String = ""
    public var meetings: [Meeting] = []
}

public struct Meeting: Identifiable, Codable, Equatable {
    public var id: String = ""
    public var type: String = ""
    public var typeCode: String = ""
    public var start: String = ""
    public var end: String = ""
    public var daysOfTheWeek: String = ""
    public var roomNumber: String = ""
    public var buildingName: String = ""
    public var instructors: [String] = []
}

// example section for previews and testing
public func exampleSection() -> CourseSection {
    return CourseSection(subject: "Electrical and Computer Engineering",
                         subjectID: "ECE",
                         course: "Computer Systems",
                         courseID: "391",
                         sectionNumber: "AD1",
                         statusCode: "UNKNOWN",
                         partOfTerm: "1",
                         sectionStatusCode: "A",
                         enrollmentStatus: "open",
                         startDate: "2020-01-01Z",
                         endDate: "2020-06-01Z",
                         meetings: [Meeting(id: "0",
                                            type: "Discussion",
                                            typeCode: "DIS",
                                            start: "6:30 AM",
                                            end: "9:30 PM",
                                            daysOfTheWeek: "TR",
                                            roomNumber: "1013",
                                            buildingName: "ECEB",
                                            instructors: ["Doe, J"])])
}

class SectionParser {
    // parse from xml
    func parseXML(data: Data) -> CourseSection? {
        let parser = Foundation.XMLParser(data: data)
        let delegate = SectionParserDelegate()
        parser.delegate = delegate
        
        if parser.parse() {
            return delegate.currentSection
        } else {
            return nil
        }
    }
    
    // parse from url
    func parseURL(urlPrefix: String, SectionID: String, completion: @escaping (CourseSection?) -> Void) {
        // Create a URLSession task to fetch the XML data
        let task = URLSession.shared.dataTask(with: URL(string: urlPrefix + "/" + SectionID + ".xml")!) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching XML data:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            // Create an XMLParser instance
            let parser = XMLParser(data: data)
        
            // Create a delegate object
            let delegate = SectionParserDelegate()
        
            // Set the delegate for the parser
            parser.delegate = delegate
        
            // Start parsing
            if parser.parse() {
                print("Section Parsing successful")
                completion(delegate.currentSection)
            } else {
                print("Section Parsing failed")
                completion(nil)
            }
        }
    
    // Resume the task to initiate the data fetching
    task.resume()
    }
}

class SectionParserDelegate: NSObject, XMLParserDelegate {
    var currentElement: String = ""
    var currentValue: String = ""
    var currentSection: CourseSection?
    var currentMeeting: Meeting?
    
    // Called when the parser starts parsing the document
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Section Parsing started")
    }
    
    // Called when the parser finishes parsing the document
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Section Parsing ended")
    }
    
    // Called for each opening tag in the XML
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "ns2:section" {
            currentSection = CourseSection()
            if let id = attributeDict["id"] {
                currentSection!.id = id
            }
        } else if elementName == "subject" {
            if let subjectID = attributeDict["id"] {
                currentSection!.subjectID = subjectID
            }
        } else if elementName == "course" {
            if let courseID = attributeDict["id"] {
                currentSection!.courseID = courseID
            }
        } else if elementName == "meeting" {
            currentMeeting = Meeting()
            if let id = attributeDict["id"] {
                currentMeeting!.id = id
            }
            print("Meeting created")
        } else if elementName == "type" {
            if let typeCode = attributeDict["code"] {
                currentMeeting!.typeCode = typeCode
            }
        }
    }
    
    // Called for each closing tag in the XML
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "meeting" && currentMeeting != nil{
            currentSection!.meetings.append(currentMeeting!)
            currentMeeting = nil
            print("Meeting added")
        }

        else if currentElement == elementName {
            if currentElement == "subject" {
                currentSection!.subject = currentValue
            } else if currentElement == "course" {
                currentSection!.course = currentValue
            } else if currentElement == "sectionNumber" {
                currentSection!.sectionNumber = currentValue
            } else if currentElement == "statusCode" {
                currentSection!.statusCode = currentValue
            } else if currentElement == "partOfTerm" {
                currentSection!.partOfTerm = currentValue
            } else if currentElement == "sectionStatusCode" {
                currentSection!.sectionStatusCode = currentValue
            } else if currentElement == "enrollmentStatus" {
                currentSection!.enrollmentStatus = currentValue
            } else if currentElement == "startDate" {
                currentSection!.startDate = currentValue
            } else if currentElement == "endDate" {
                currentSection!.endDate = currentValue
            }
        
            else if currentElement == "type" && currentMeeting != nil {
                currentMeeting!.type = currentValue
            } else if currentElement == "start" && currentMeeting != nil {
                currentMeeting!.start = currentValue
            } else if currentElement == "end" && currentMeeting != nil {
                currentMeeting!.end = currentValue
            } else if currentElement == "daysOfTheWeek" && currentMeeting != nil {
                currentMeeting!.daysOfTheWeek = currentValue
            } else if currentElement == "roomNumber" && currentMeeting != nil {
                currentMeeting!.roomNumber = currentValue
            } else if currentElement == "buildingName" && currentMeeting != nil {
                currentMeeting!.buildingName = currentValue
            } else if currentElement == "instructor" && currentMeeting != nil {
                currentMeeting!.instructors.append(currentValue)
            }
        }
        currentValue = ""
    }
    
    // Called for the content of each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }
}
