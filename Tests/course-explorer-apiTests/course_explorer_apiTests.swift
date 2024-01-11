import XCTest
@testable import course_explorer_api

// XCTest Documentation
// https://developer.apple.com/documentation/xctest

// Defining Test Cases and Test Methods
// https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods

final class course_explorer_apiTests: XCTestCase {
    func sectionTest() async throws {
        let xmlParserDelegate = SectionParser()
        xmlParserDelegate.parseXMLFromURL(year: "2023", semester: "spring", subject: "ACES", course: "102", section: "63906") { section in
            XCTAssertNotNil(section, "Section is nil")

            //print("Parsing completed successfully")
            
            //print("Course Code:", section!.subjectID! + " " + section!.courseID!)
            XCTAssert(section!.subjectID! == "ACES", "Subject Mismatch")
            
            print("Subject:", section!.subject!)
            print("Course:", section!.course!)
            print("Section Number:", section!.sectionNumber!)
            print("Status Code:", section!.statusCode!)
            print("Enrollment Status:", section!.enrollmentStatus!)
            print("Part of Term:", section!.partOfTerm!)
            print("Section Status Code:", section!.sectionStatusCode!)
            print("Start Date:", section!.startDate!)
            print("End Date:", section!.endDate!)
            print(String(section!.meetings.count) + " Meetings:")
            for meeting in section!.meetings {
                print("  Meeting ID:", meeting.id!)
                print("  Type:", meeting.type!)
                print("  Type Code:", meeting.typeCode!)
                print("  Start:", meeting.start!)
                print("  End:", meeting.end!)
                print("  Days of the Week:", meeting.daysOfTheWeek!)
                print("  Room Number:", meeting.roomNumber!)
                print("  Building Name:", meeting.buildingName!)
                print("  " + String(meeting.instructors.count) + " Instructors:", meeting.instructors)
            }
        }
    }
}
