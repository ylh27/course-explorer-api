import Foundation

public func fetchAll(completion: @escaping ([CourseSection]?) -> Void) {
    
}

func traverseSemester(urlPrefix: String, completion: @escaping ([CourseSection]?) -> Void) {
    let url = URL(string: urlPrefix + ".xml")!
    let semesterParser = IdParser(parentTag: "subjects", childTag: "subject")
    
    semesterParser.parseURL(url: url) { list in
        if list == nil {
            print("parsing '" + urlPrefix + ".xml' unsucessful")
            completion(nil)
        }
        print("semester list parsed")
        var count = 0
        var returnList: [CourseSection] = []
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
