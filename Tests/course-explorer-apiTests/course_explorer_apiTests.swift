import XCTest
@testable import course_explorer_api

// XCTest Documentation
// https://developer.apple.com/documentation/xctest

// Defining Test Cases and Test Methods
// https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods

final class course_explorer_apiTests: XCTestCase {
    func testSection() {
        let xmlString = """
            <ns2:section id="63906" href="https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring/ACES/102/63906.xml">
                <parents>
                    <calendarYear id="2023" href="https://courses.illinois.edu/cisapp/explorer/schedule/2023.xml">2023</calendarYear>
                    <term id="120231" href="https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring.xml">Spring 2023</term>
                    <subject id="ACES" href="https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring/ACES.xml">Agricultural, Consumer and Environmental Sciences</subject>
                    <course id="102" href="https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring/ACES/102.xml">Intro Sustainable Food Systems</course>
                </parents>
                <sectionNumber>LR </sectionNumber>
                <creditHours>3 hours</creditHours>
                <statusCode>A</statusCode>
                <sectionText>
                    ACES 102 is a hybrid course that requires students to complete a portion of the course content online prior to attending the face-to-face class sessions.
                </sectionText>
                <partOfTerm>A</partOfTerm>
                <sectionStatusCode>A</sectionStatusCode>
                <enrollmentStatus>UNKNOWN</enrollmentStatus>
                <startDate>2023-01-17Z</startDate>
                <endDate>2023-03-10Z</endDate>
                <meetings>
                    <meeting id="0">
                        <type code="LCD">Lecture-Discussion</type>
                        <start>02:00 PM</start>
                        <end>03:20 PM</end>
                        <daysOfTheWeek>TR </daysOfTheWeek>
                        <roomNumber>166</roomNumber>
                        <buildingName>Bevier Hall</buildingName>
                        <instructors>
                            <instructor lastName="Ball" firstName="A">Ball, A</instructor>
                        </instructors>
                    </meeting>
                </meetings>
            </ns2:section>
        """
    
        let data = xmlString.data(using: .utf8)!
        let sectionParser = SectionParser()
        
        // Act
        let section = sectionParser.parseXML(data: data)
        
        // Assert
        XCTAssertNotNil(section, "Parsing should be successful")
        XCTAssertEqual(section?.subjectID, "ACES", "Subject should be 'ACES'")
        XCTAssertEqual(section?.courseID, "102", "Course should be '102'")
    }

    func testSectionURL() {
        let expectation = XCTestExpectation(description: "Parsing XML from URL")
        let url = URL(string: "https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring/ACES/102/63906.xml")!
        let sectionParser = SectionParser()
        
        sectionParser.parseURL(url: url) { section in
            // Assert
            XCTAssertNotNil(section, "Parsing should be successful")
            XCTAssertEqual(section?.subjectID, "ACES", "Subject should be 'ACES'")
            XCTAssertEqual(section?.courseID, "102", "Course should be '102'")
            
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a reasonable timeout
        wait(for: [expectation], timeout: 5.0)
    }
}
