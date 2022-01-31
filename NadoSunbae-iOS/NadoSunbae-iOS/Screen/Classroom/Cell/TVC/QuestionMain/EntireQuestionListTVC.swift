//
//  EntireQuestionListTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import UIKit

class EntireQuestionListTVC: BaseQuestionTVC {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 10))
    }
}
