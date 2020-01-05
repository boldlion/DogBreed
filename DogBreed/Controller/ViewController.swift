//
//  ViewController.swift
//  RandomDog
//
//  Created by Bold Lion on 3.01.20.
//  Copyright © 2020 Bold Lion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    var breeds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DogApi.requestBreedsList(completion: handleBreedsListResponse(breeds:error:))
    }
    
    func handleRandomImageResponse(dogImage: DogImage?, error: Error?) {
        guard let imageUrl = URL(string: dogImage?.message ?? "") else { return }
        DogApi.requestImageFile(url: imageUrl, completion: self.handleImageFileResponse(image:error:))
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async { [unowned self] in
            self.imageView.image = image
        }
    }
    
    func handleBreedsListResponse(breeds: [String], error: Error?) {
        self.breeds = breeds
        DispatchQueue.main.async { [unowned self] in
            self.pickerView.reloadAllComponents()
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogApi.requestRandomImage(breed: breeds[row], completion: handleRandomImageResponse(dogImage:error:))
    }
}
