//
//  NadoSunbaeBtn.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/07.
//

import UIKit

/**
 - Description:
 나도선배에서 자주 사용되는 bg: .nadoBlack/ font: .mainDefault 컬러의 각진 모양 버튼
 폰트는 Pretendard-SemiBold: 16pt가 기본이고 이외에는 메서드를 통해 커스텀하여 사용
 
 - Note:
 - setButton: 버튼 기본 셋팅 변경
 - setTitle: 버튼 타이틀만 변경
 - changeColors: 버튼 배경색, 글씨색 변경
 */
class NadoSunbaeBtn: UIButton {
    
    // MARK: Properties
    var isActivated: Bool = false {
        didSet {
            self.backgroundColor = self.isActivated ? activatedBgColor : normalBgColor
            self.setTitleColor(self.isActivated ? activatedFontColor : normalFontColor, for: .normal)
            self.isEnabled = isActivated
        }
    }
    
    private var normalBgColor: UIColor = .gray1
    private var normalFontColor: UIColor = .gray3
    private var activatedBgColor: UIColor = .nadoBlack
    private var activatedFontColor: UIColor = .mainDefault
    
    init() {
        super.init(frame: .zero)
        setDefaultStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setDefaultStyle()
    }
    
    // MARK: Private Methods
    /// 디폴트 버튼 스타일 설정
    private func setDefaultStyle() {
        self.makeRounded(cornerRadius: 14.adjusted)
        self.titleLabel?.font = .PretendardSB(size: 16)
        self.backgroundColor = self.normalBgColor
        self.setTitleColor(self.normalFontColor, for: .normal)
    }
    
    // MARK: Public Methods
    func setBtnColors(normalBgColor: UIColor, normalFontColor: UIColor, activatedBgColor: UIColor, activatedFontColor: UIColor) {
        self.normalBgColor = normalBgColor
        self.normalFontColor = normalFontColor
        self.activatedBgColor = activatedBgColor
        self.activatedFontColor = activatedFontColor
    }
    
    /// 버튼 타이틀과 스타일 변경 폰트 사이즈 adjusted 적용
    func setTitleWithStyle(title: String, size: CGFloat, weight: FontWeight = .regular) {
        let font: UIFont
        
        switch weight {
        case .light:
            font = .PretendardL(size: size.adjusted)
        case .regular:
            font = .PretendardR(size: size.adjusted)
        case .medium:
            font = .PretendardM(size: size.adjusted)
        case .bold:
            font = .PretendardB(size: size.adjusted)
        case .semiBold:
            font = .PretendardSB(size: size.adjusted)
        }
        
        self.titleLabel?.font = font
        self.setTitle(title, for: .normal)
    }
}
