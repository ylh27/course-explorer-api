import Foundation

public func fetchAll(urlPrefix: String, completion: @escaping ([CourseSection]?) -> Void) {
    
}

public func traverseSemester(urlPrefix: String, completion: @escaping ([Course]?) -> Void) {
    let url = URL(string: urlPrefix + ".xml")!
    let semesterParser = IdParser(parentTag: "subjects", childTag: "subject")
    
    semesterParser.parseURL(url: url) { list in
        if list == nil {
            print("parsing '" + urlPrefix + ".xml' unsucessful")
            completion(nil)
        }
        print("semester list parsed")
        var count = 0
        var returnList: [Course] = []
        for subject in list! {
            print("parsing " + urlPrefix+"/"+subject+".xml")
            traverseSubject(urlPrefix: urlPrefix+"/"+subject) { SectionList in
                returnList += SectionList!
                count += 1
                print(String(count) + "/" + String(list!.count) + " Subjects")
                if count == list!.count {
                    completion(returnList)
                }
            }
        }
    }
}

public func getYears(urlPrefix: String, completion: @escaping ([String]?) -> Void) {
    let url = URL(string: urlPrefix + ".xml")!
    let yearParser = IdParser(parentTag: "calendarYears", childTag: "calendarYear")
    
    yearParser.parseURL(url: url) { list in
        if list == nil {
            print("parsing '" + urlPrefix + ".xml' unsucessful")
            completion(nil)
        }
        completion(list)
    }
}
