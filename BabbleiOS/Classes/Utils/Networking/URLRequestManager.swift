//
//  URLRequestManager.swift
//  1Flow
//
//  Created by Rohan Moradiya on 30/04/22.
//

import Foundation

protocol URLRequestManagerProtocol {
    func getAPIWith(_ endPoint: String, header: [String: String], completion: @escaping APICompletionBlock)
    func postAPIWith(_ endPoint: String, parameters: Data, header: [String: String], completion: @escaping APICompletionBlock)
}

class URLRequestManager: URLRequestManagerProtocol {
    let BaseURL: String = "https://pri9rvopx2.execute-api.ap-south-1.amazonaws.com/prod-2/"
    func getAPIWith(_ endPoint: String, header: [String: String], completion: @escaping APICompletionBlock) {
        var request = URLRequest(url: URL(string: "\(BaseURL)\(endPoint)")!)
        request.httpMethod = "GET"
        header.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        BabbleLog.writeLog("API Call: \(endPoint)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                BabbleLog.writeLog("API Call: \(endPoint) - Failed: \(error.localizedDescription)")
                completion(false, error, nil)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode==200) {
                    BabbleLog.writeLog("API Call: \(endPoint) success")
                    completion(true, nil, data)
                    return
                }else{
                    completion(false, nil, data)
                }
            }
        }.resume()
    }
    
    func postAPIWith(_ endPoint: String, parameters: Data, header: [String: String], completion: @escaping APICompletionBlock) {
        let BaseURL: String = "https://pri9rvopx2.execute-api.ap-south-1.amazonaws.com/prod-2/"
        var request = URLRequest(url: URL(string: "\(BaseURL)\(endPoint)")!)
        request.httpMethod = "POST"
        request.httpBody = parameters
        header.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        BabbleLog.writeLog("API Call: \(endPoint)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                BabbleLog.writeLog("API Call: \(endPoint) - Failed: \(error.localizedDescription)")
                completion(false, error, nil)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode==200) {
                    BabbleLog.writeLog("API Call: \(endPoint) success")
                    completion(true, nil, data)
                    return
                }else{
                    completion(false, nil, data)
                }
            }
            
        }.resume()
    }
}
