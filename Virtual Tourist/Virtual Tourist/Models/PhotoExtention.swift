//
//  PhotoExtention.swift
//  Virtual Tourist
//
//  Created by Enas Alrehaili on 2019-12-23.
//  Copyright © 2019 Enas Alrehaili. All rights reserved.
//

import UIKit
extension Photo {
    func set(image: UIImage) {
        self.image = image.pngData()
    }
    func getImage() -> UIImage? {
        return(image == nil) ? nil : UIImage(data: image!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
