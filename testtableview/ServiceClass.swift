//
//  ServiceClass.swift
//  testtableview
//
//  Created by Nitesh Garg on 20/03/21.
//

import Foundation

struct Request: Encodable {
    var key: String
    var q: String
    var image_type: String
}

struct Response: Decodable {
    
}

protocol ServiceNetworkType {
    func getdata(req: Request, completion: @escaping (_ result: Result<Response,Error>) -> Void)
    func readDataFromJasonFile(completion: (_ result: Result<[Dictionary<String, AnyObject>], Error>) -> Void)
}

class ServiceClass: ServiceNetworkType {
    
    func getdata(req: Request, completion: @escaping (_ result: Result<Response,Error>) -> Void) {
        getServiceDate(header: nil, req: req, completion: completion)
    }
}

extension ServiceClass {
    
    func readDataFromJasonFile(completion: (_ result: Result<[Dictionary<String, AnyObject>], Error>) -> Void){
        if let path = Bundle.main.path(forResource: "menu", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult1 = jsonResult as? [Dictionary<String, AnyObject>] {
                    print(jsonResult1)
                    completion(.success(jsonResult1))
                  }
              } catch let error {
                   // handle error
                completion(.failure(error))
              }
        }
    }
    
    func getServiceDate<T: Decodable, Q: Encodable>(header: [String: String]?, req: Q , completion: @escaping (_ result: Result<T,Error>) -> Void) -> Void {
        
        guard let url = URL(string: "https://pixabay.com/api/?key=17173870-1354e798802153a0d6d7e564a&q=\((req as! Request).q)&image_type=photo") else { return }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 300
        if header != nil {
            config.httpAdditionalHeaders = header
        }
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        session.dataTask(with: request) { (data, resp, error) in
            if let response = resp {
                print(resp)
            }
            
            if error != nil {
                completion(.failure(error!))
            }
            do {
                   let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                   print(json)
               } catch {
                   print("error")
               }
            
            guard let respdata = data else {return}
            do {
                let data = try JSONDecoder().decode(T.self, from: respdata)
                completion(.success(data))
            } catch let jasonError{
                completion(.failure(jasonError))

            }
        }.resume()
    }
}
