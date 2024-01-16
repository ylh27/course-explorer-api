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
        
        CourseParser().parseURL(urlPrefix: "https://courses.illinois.edu/cisapp/explorer/schedule/2024/spring/AAS", course: "100") { course in
            // Assert
            XCTAssertNotNil(course, "Parsing should be successful")
            XCTAssertEqual(course?.sections.count, 11, "List should have count of 11")
            print(course!)
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

    func testSubjectTraversal() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        let urlPrefix = "https://courses.illinois.edu/cisapp/explorer/schedule/2024/spring/ECE"
        
        traverseSubject(urlPrefix: urlPrefix) { list in
            // Assert
            XCTAssertNotNil(list, "Parsing should be successful")
            //XCTAssertEqual(list?.count, 11, "List should have count of 11")
            print("Total of " + String(list!.count) + " sections.")
            print(list![0])
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 30.0)

    }
    
    func testSemesterTraversal() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        let urlPrefix = "https://courses.illinois.edu/cisapp/explorer/schedule/2024/spring"
        
        traverseSemester(urlPrefix: urlPrefix) { list in
            // Assert
            XCTAssertNotNil(list, "Parsing should be successful")
            //XCTAssertEqual(list?.count, 11, "List should have count of 11")
            print("Total of " + String(list!.count) + " subjects.")
            print(list![0])
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 30.0)

    }
    
    func testGetYears() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        let urlPrefix = "https://courses.illinois.edu/cisapp/explorer/schedule"
        
        getYears(urlPrefix: urlPrefix) { list in
            // Assert
            XCTAssertNotNil(list, "Parsing should be successful")
            //XCTAssertEqual(list?.count, 11, "List should have count of 11")
            print("Total of " + String(list!.count) + " years.")
            print(list!)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 30.0)
    }
    
}
