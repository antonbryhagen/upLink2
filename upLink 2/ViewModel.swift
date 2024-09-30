//
//  ViewModel.swift
//  RestFullApp
//
//  Created by Anton Bryhagen on 2024-09-20.
//

import Foundation
import SwiftUI
import Security

struct DataPoint: Hashable, Codable {
    let category: String
    let parameterId: String
    let parameterName: String
    let timestamp: String
    let value: Float
    let strVal: String

}

class ViewModel: ObservableObject {
    
    let keychainHandler = KeychainHandler()
    
    func decodeJWTExp(_ token: String) -> Date?{
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return nil }
        
        let payload = segments[1]
        var base64String = String(payload)
        
        base64String = base64String.replacingOccurrences(of: "-", with: "+")
        base64String = base64String.replacingOccurrences(of: "_", with: "/")
        
        while base64String.count % 4 != 0{
            base64String.append("=")
        }
        
        guard let decodedData = Data(base64Encoded: base64String) else { return nil }
        
        if let json = try? JSONSerialization.jsonObject(with: decodedData, options: []),
           let payloadDict = json as? [String: Any],
           let expTimestamp = payloadDict["exp"] as? Double {
            return Date(timeIntervalSince1970: expTimestamp)
        }
        
        return nil
    }
    
    func fetchJWTToken(clientID: String, clientSecret: String, completion: @escaping (String?) -> Void){
        var fetchNewToken: Bool = false
        
        if let token = self.keychainHandler.getFromKeychain(key: "jwtToken") {
            if let expirationDate = decodeJWTExp(token), expirationDate > Date() {
                //valid token found in keychain
                print("Using old jwt")
                completion(token)
            }else {
                //invalid token found, fetch new one
                print("Found old jwt")
                fetchNewToken = true
            }
        }else {
            //no token found, fetch new one
            print("No jwt found")
            fetchNewToken = true
        }
        
        if(fetchNewToken) {
            guard let url = URL(string: "https://api.myuplink.com/oauth/token") else {
                print("Invalid URL")
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let loginString = "\(clientID):\(clientSecret)"
            let loginData = loginString.data(using: .utf8)!
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
            let bodyParameters = "grant_type=client_credentials&scope=READSYSTEM WRITESYSTEM"
            request.httpBody = bodyParameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("error: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response or data")
                    completion(nil)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let accessToken = json["access_token"] as? String {
                        print("Got access token")
                        completion(accessToken)
                    }else{
                        print("Token not found in response")
                        completion(nil)
                    }
                } catch {
                    print("Error parsing JSON")
                    completion(nil)
                }
            }
            
            task.resume()
        }
        
        
    }
    
    @Published var dataPoints: [DataPoint] = []
    @Published var selectedDataPoints: [String] = []
    
    init() {
        if let savedSelectedDataPoints = UserDefaults.standard.array(forKey: "selectedDataPoints") as? [String] {
            self.selectedDataPoints = savedSelectedDataPoints
        }else {
            self.selectedDataPoints = []
        }
    }
    
    func getTokenAndProceed() {
        let clientID = keychainHandler.getFromKeychain(key: "clientId") ?? ""
        let clientSecret = keychainHandler.getFromKeychain(key: "clientSecret") ?? ""
        fetchJWTToken(clientID: clientID, clientSecret: clientSecret) { token in
            if let token = token {
                print("Token received")
                // Proceed with token-based logic
                //self.saveToKeychain(token: token)
                self.keychainHandler.saveToKeychain(key: "jwtToken", value: token)
                self.fetch(jwtToken: token)
            } else {
                print("Failed to retrieve access token")
            }
        }
    }
    func fetch(jwtToken: String){
        let deviceID = keychainHandler.getFromKeychain(key: "deviceId") ?? ""
        
        guard let url = URL(string: "https://api.myuplink.com/v2/devices/\(deviceID)/points") else {
            return
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("text/json", forHTTPHeaderField: "accept")
        request.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _,
            error in
            guard let data = data, error == nil else {
                print("FAILED")
                return
            }
            
            // convert to JSON
            do {
                let dataPoints = try
                    JSONDecoder().decode([DataPoint].self, from:
                    data)
                DispatchQueue.main.async {
                    self?.dataPoints = dataPoints
                }
                print("GOT DATA POINTS")
            
            }
            catch {
                //let errorPoint = DataPoint(category: "Error", parameterId: "Error", parameterName: "Error fetching data", timestamp: "", value: 0, strVal: "Error")
                //self?.dataPoints = [errorPoint]
                print(error)
            }
        }
        
        task.resume()
    }
}
