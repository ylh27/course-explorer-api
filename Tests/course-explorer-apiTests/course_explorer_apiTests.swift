import XCTest
@testable import course_explorer_api

// XCTest Documentation
// https://developer.apple.com/documentation/xctest

// Defining Test Cases and Test Methods
// https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods

final class course_explorer_apiTests: XCTestCase {

    func testSectionURL() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        //let url = URL(string: "https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring/ACES/102/63906.xml")!
        let sectionParser = SectionParser()
        
        sectionParser.parseURL(urlPrefix: "https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring/ACES/102", SectionID: "63906") { section in
            // Assert
            XCTAssertNotNil(section, "Parsing should be successful")
            XCTAssertEqual(section?.subjectID, "ACES", "Subject should be 'ACES'")
            XCTAssertEqual(section?.courseID, "102", "Course should be '102'")
            
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCourseURL() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        let url = URL(string: "https://courses.illinois.edu/cisapp/explorer/schedule/2024/spring/AAS/100.xml")!
        let courseParser = IdParser(parentTag: "sections", childTag: "section")
        
        courseParser.parseURL(url: url) { list in
            // Assert
            XCTAssertNotNil(list, "Parsing should be successful")
            XCTAssertEqual(list?.count, 11, "List should have count of 14")
            XCTAssertEqual(list?[5], "50105", "2nd list in should have id '201'")
            print(list!)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 5.0)
    }

    func testSubjectURL() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        let url = URL(string: "https://courses.illinois.edu/cisapp/explorer/schedule/2024/spring/AAS.xml")!
        let subjectParser = IdParser(parentTag: "courses", childTag: "course")
        
        subjectParser.parseURL(url: url) { list in
            // Assert
            XCTAssertNotNil(list, "Parsing should be successful")
            XCTAssertEqual(list?.count, 14, "List should have count of 14")
            XCTAssertEqual(list?[2], "201", "2nd list in should have id '201'")
            print(list!)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCourseTraversal() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        let urlPrefix = "https://courses.illinois.edu/cisapp/explorer/schedule/2024/spring/AAS/100"
        
        traverseCourse(urlPrefix: urlPrefix) { list in
            // Assert
            XCTAssertNotNil(list, "Parsing should be successful")
            XCTAssertEqual(list?.count, 11, "List should have count of 11")
            print(list![0])
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 15.0)

    }

}
