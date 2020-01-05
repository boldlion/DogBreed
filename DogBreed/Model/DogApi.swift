//
//  DogApi.swift
//  RandomDog
//
//  Created by Bold Lion on 3.01.20.
//  Copyright © 2020 Bold Lion. All rights reserved.
//

import UIKit

class DogApi {
    
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case allListBreed

        var stringValue: String {
            switch self {
                case .randomImageFromAllDogsCollection:
                    return "https://dog.ceo/api/breeds/image/random"
                case .randomImageForBreed(let breed):
                    return "https://dog.ceo/api/breed/\(breed)/images/random"
                case .allListBreed:
                    return "https://dog.ceo/api/breeds/list/all"
            }
        }
        
        var url: URL? {
            guard let url = URL(string: self.stringValue) else { return nil }
            return url
        }
    }
    
    class func requestImageFile(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url ) { (data, response, error) in
            guard let data = data else {
                completion(nil, error!)
                return
            }
            let downloadedImage = UIImage(data: data)
            completion(downloadedImage, nil)
        }
        task.resume()
    }
    
    class func requestRandomImage(breed: String, completion: @escaping (DogImage?, Error?) -> Void) {
        guard let url = DogApi.Endpoint.randomImageForBreed(breed).url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let dogImage = try decoder.decode(DogImage.self, from: data)
                completion(dogImage, nil)
            }
            catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func requestBreedsList(completion: @escaping ([String], Error?) -> Void) {
        guard let url = Endpoint.allListBreed.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let breedsResponseDict = try decoder.decode(BreedsListResponse.self, from: data)
                let breedsArray = breedsResponseDict.message.keys.map { $0 }
                completion(breedsArray, nil)
            }
            catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
}
