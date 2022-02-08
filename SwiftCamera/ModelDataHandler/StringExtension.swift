//
//  StringExtension.swift
//  SwiftCamera
//
//  Created by dev on 2022/01/26.
//

import UIKit

extension String {

  /**This method gets size of a string with a particular font.
   */
  func size(usingFont font: UIFont) -> CGSize {
    return size(withAttributes: [.font: font])
  }

}
