//
//  APIService.swift
//  Opuz
//
//  Created by Admin on 2021/10/13.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    private init() {
        
    }
    
    func search(key: String, completion: @escaping (Error?, Any?, Int?)->()) {

        let url = Constants.SEARCH_URL + key

        AF.request(URL(string: url)!, method: .get, encoding: JSONEncoding.default).responseString {
            response in

            switch response.result {
            case .success(let data):
                let status = response.response?.statusCode ?? 0
                completion(nil, data, status)
            case .failure(let error):
                completion(error, nil, 0)
            }
        }
    }
}
