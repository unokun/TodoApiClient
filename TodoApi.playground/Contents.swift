import Foundation
import PlaygroundSupport

// 非同期処理用
PlaygroundPage.current.needsIndefiniteExecution = true

//
// Http Requestヘッダにパラメータを設定する方法
// https://stackoverflow.com/questions/36372341/swift-http-request-with-parameters-in-header

let TODOAPI_BASEURL = "https://sample-api.codecamp.jp/api/v1"

struct JsonFeed: Codable {
    let results: Results
}
struct Results: Codable {
    let uuid: String?
    let todo: [Todo]?
}

struct Todo: Codable {
    let id: String
    let subject: String
    let body: String
    let limit: String
    let status: Int
}

struct PostTodo: Codable {
    let subject: String
    let body: String
    let limit: String
}
struct TodoStatus: Codable {
    let status: Int
}

var uuid = ""

class URLSessionGetClient {
    
    func callApi(url urlString: String, method: String, parameters: [String: String], headers: [String: String], bodyParam: Data? = nil) {
        var compnents = URLComponents(string: urlString)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        compnents?.queryItems = queryItems

        var request = URLRequest(url: (compnents?.url)!)
        request.httpMethod = method
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = bodyParam {
            request.httpBody = body
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                                print(response)
                do {
//                                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                                        print(type(of: json))
//                                        print(json)
                    let decoder = JSONDecoder()
                    let feed = try decoder.decode(JsonFeed.self, from: data)
                    
                    if let uuid = feed.results.uuid {
                        print(uuid)
                    }
                    
                    if let todos = feed.results.todo {
                        for todo in todos {
                            print(todo.id)
                            print(todo.subject)
                            print(todo.body)
                            print(todo.limit)
                            print(todo.status)
                        }
                    }
                    // UI更新
                    // DispatchQueue.main.async {
                    // }
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        
        task.resume()
    }
    
}
func doRequest() {
    let urlSessionGetClient = URLSessionGetClient()

    let parameters: [String: String] = [:]
    // uuid取得
//    let headers: [String: String] = ["Content-Type": "application/json", "X-REQUEST-UUID":""]
    //    urlSessionGetClient.callApi(url: TODOAPI_BASEURL + "/uuid/issue", method: "POST", parameters: parameters, headers: headers, todoParam: nil)
    
    // Todo一覧
//    let headers: [String: String] = ["Content-Type": "application/json", "X-REQUEST-UUID":"d314000b53815a2d674cf9416dc0d427b0f47952"]
//    urlSessionGetClient.callApi(url: TODOAPI_BASEURL + "/todo/list/1", method: "GET", parameters: parameters, headers: headers)

    // Todo作成
//    let headers: [String: String] = ["Content-Type": "application/json", "X-REQUEST-UUID":"d314000b53815a2d674cf9416dc0d427b0f47952"]
//    let todo = PostTodo(subject: "タイトル", body: "本文", limit: "2018-10-31T00:00:00+09:00")
//    do {
//        let bodyParam = try JSONEncoder().encode(todo)
//        print(bodyParam)
//        urlSessionGetClient.callApi(url: TODOAPI_BASEURL + "/todo/create", method: "POST", parameters: parameters, headers: headers, bodyParam: bodyParam)
//    } catch {
//        print("encode error")
//    }
    // status更新
    let headers: [String: String] = ["Content-Type": "application/json", "X-REQUEST-UUID":"d314000b53815a2d674cf9416dc0d427b0f47952"]
    let todo = TodoStatus(status: 2)
    do {
        let bodyParam = try JSONEncoder().encode(todo)
        print(bodyParam)
        urlSessionGetClient.callApi(url: TODOAPI_BASEURL + "/todo/update/298", method: "POST", parameters: parameters, headers: headers, bodyParam: bodyParam)
    } catch {
        print("encode error")
    }
}

doRequest()
