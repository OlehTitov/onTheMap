//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Oleh Titov on 01.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        static var firstName = ""
        static var lastName = ""
        static var initialSubmit = false
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case getStudentLocation(String, String)
        case getPublicUserData(String)
        case postStudentLocation
        case updateStudentLocation(String)
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
            case .getStudentLocation(let limit, let order): return Endpoints.base + "StudentLocation" + "?limit=\(limit)" + "&order=\(order)updatedAt"
            case .getPublicUserData(let id): return Endpoints.base + "users/\(id)"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.base + "StudentLocation/" + "\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPostRequest(url: Endpoints.login.url, response: SessionResponse.self, body: SessionPost(udacity: StudentCredentials(username: username, password: password)), httpMethod: "POST") { (response, httpResponse, error)  in
            if let response = response {
                Auth.accountKey = response.account.key
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getPublicUserData(id: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getPublicUserData(id).url, response: PublicUserData.self) { (response, error) in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, HTTPURLResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                completion(true, httpResponse, nil)
            } else {
                completion(false, response as? HTTPURLResponse, error)
            }
        }
        task.resume()
    }
    
    class func getStudentLocation(limit: String, order: String, completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getStudentLocation(limit, order).url, response: GetStudentLocation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        taskForPostRequest(url: Endpoints.postStudentLocation.url, response: PostLocationResponse.self, body: PostLocation(uniqueKey: CurrentStudent.Location.uniqueKey, firstName: CurrentStudent.Location.firstName, lastName: CurrentStudent.Location.lastName, mapString: CurrentStudent.Location.mapString, mediaURL: CurrentStudent.Location.mediaURL, latitude: CurrentStudent.Location.latitude, longitude: CurrentStudent.Location.longitude), httpMethod: "POST") { (response, httpResponse, error) in
            if let response = response {
                CurrentStudent.Location.objectId = response.objectId
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func updateStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        taskForPostRequest(url: Endpoints.updateStudentLocation(CurrentStudent.Location.objectId).url, response: PutLocationResponse.self, body: PostLocation(uniqueKey: CurrentStudent.Location.uniqueKey, firstName: CurrentStudent.Location.firstName, lastName: CurrentStudent.Location.lastName, mapString: CurrentStudent.Location.mapString, mediaURL: CurrentStudent.Location.mediaURL, latitude: CurrentStudent.Location.latitude, longitude: CurrentStudent.Location.longitude), httpMethod: "PUT") { (response, httpResponse, error) in
            if let response = response {
                print(response.updatedAt)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, httpMethod: String, completion: @escaping (ResponseType?, HTTPURLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, httpResponse, error)
                }
                return
            }
            
            var numberOfSymbolsToCut = 0
            let URLString = url.absoluteString
            if URLString.contains("StudentLocation") {
                numberOfSymbolsToCut = 0
            } else {
                numberOfSymbolsToCut = 5
            }
            let range = numberOfSymbolsToCut..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, httpResponse, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, httpResponse, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, httpResponse, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var numberOfSymbolsToCut = 0
            let URLString = url.absoluteString
            if URLString.contains("StudentLocation") {
                numberOfSymbolsToCut = 0
            } else {
                numberOfSymbolsToCut = 5
            }
            let range = numberOfSymbolsToCut..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            
            do {
                //print(String(data: newData, encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func validateUrl (urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
}
