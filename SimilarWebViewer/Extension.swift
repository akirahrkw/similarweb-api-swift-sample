//
//  Extension.swift
//  SimilarWebViewer
//
//  Created by Hirakawa Akira on 26/8/14.
//  Copyright (c) 2014 Hirakawa Akira. All rights reserved.
//

extension String {

    func rank() -> String {
        if (self == "1") {
            return "1st"
        } else if (self == "2") {
            return "2nd"
        } else if (self == "3") {
            return "3rd"
        } else {
            return self + "th"
        }
    }
}
