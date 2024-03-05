//
//  SimpleNetworking.swift
//
//  Created by STL on 05/03/24.
//

import Foundation

// Enumeration is represents possible error
public enum NetworkError: Error {
    case badRequest
    case decodingError
}

// clouser takes a result and call when network request is completed
public class Webservice {
    
    public init() { } 
    
    // fetch data from specific URL
    public func fetch<T: Codable>(url: URL, parse: @escaping (Data) -> T?, completion: @escaping (Result<T?, NetworkError>) -> Void)  {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else {
                completion(.failure(.decodingError))
                return
            }
            let result = parse(data)
            completion(.success(result))
            
        }.resume()
        
    }
    
}

//
//public class Webservice {
//    func fetch(url: URL, parse: @escaping (Data) -> Void?, completion: @escaping (Result<Void, Error>) -> Void) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completion(.failure(APIError.httpError(statusCode: response.)))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(APIError.invalidData))
//                return
//            }
//            
//            parse(data)
//            completion(.success(()))
//        }
//        task.resume()
//    }
//}


public protocol APIClient {
    associatedtype ResponseType: Decodable
    
    func callAPI<T: Encodable>(endpoint: String, method: String, body: T?, completion: @escaping (Result<ResponseType, Error>) -> Void)
}

public class GenericAPIClient<ResponseType: Decodable>: APIClient {
    
    private let session: URLSession
    private let baseURL: URL
    
    public init(session: URLSession = .shared, baseURL: URL) {
        self.session = session
        self.baseURL = baseURL
    }
        
    public func callAPI<T: Encodable>(endpoint: String, method: String, body: T?, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(APIError.httpError(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

public enum APIError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case invalidData
}
