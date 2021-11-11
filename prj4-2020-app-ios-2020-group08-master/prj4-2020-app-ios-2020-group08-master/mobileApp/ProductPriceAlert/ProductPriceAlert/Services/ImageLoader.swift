//
// Created by Paul Severin on 15.04.20.
// Copyright (c) 2020 Fontys UAS. All rights reserved.
//

import Foundation
import UIKit

func loadImage(base64String : String) -> UIImage {
    Data(base64Encoded: base64String) // create Data object from base64 string
            .flatMap {UIImage(data: ($0))} // if successful create Image from it
            ?? UIImage() // use empty image as placeholder in case of failure
}
