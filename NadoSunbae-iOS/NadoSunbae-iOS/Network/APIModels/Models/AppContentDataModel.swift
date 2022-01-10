//
//  AppContentDataModel.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

/// 후기 뷰 학과 이름 리스트 위한 모델
struct ReviewData {
    let majorName: String
}

/// 후기 뷰 메인 이미지 위한 모델
struct ReviewImgData {
    let reviewImgName: String
    
    func makeImg() -> UIImage? {
        return UIImage(named: reviewImgName)
    }
}
