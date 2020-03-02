//
//  RoundImage.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 06/02/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func roundedImage () {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
