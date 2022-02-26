//
//  URLSessionExtensions.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation

extension URLSession {
    func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
    
    func synchronousDataTask(with url: URL, completion: (Data?, URLResponse?, Error?) -> Void) {
        let (data, response, error) = synchronousDataTask(with: url)
        completion(data, response, error)
    }
}

extension Optional where Wrapped == URLResponse {
    var isSuccess: Bool {
        (self as? HTTPURLResponse)?.isSuccess ?? false
    }
    
    var isRedirection: Bool {
        (self as? HTTPURLResponse)?.isRedirection ?? false
    }
    
    var isClientError: Bool {
        (self as? HTTPURLResponse)?.isClientError ?? false
    }
    
    var isServerError: Bool {
        (self as? HTTPURLResponse)?.isServerError ?? false
    }
    
    func isHttpStatus(range: Int) -> Bool {
        guard let http = self as? HTTPURLResponse else {
            return false
        }
        
        return http.isHttpStatus(range: range)
    }
}

extension URLResponse {
    var isSuccess: Bool {
        isHttpStatus(range: 200)
    }
    
    var isRedirection: Bool {
        isHttpStatus(range: 300)
    }
    
    var isClientError: Bool {
        isHttpStatus(range: 400)
    }
    
    var isServerError: Bool {
        isHttpStatus(range: 400)
    }
    
    func isHttpStatus(range: Int) -> Bool {
        guard let http = self as? HTTPURLResponse else {
            return false
        }
        
        return http.statusCode / 100 == range / 100
    }
}
