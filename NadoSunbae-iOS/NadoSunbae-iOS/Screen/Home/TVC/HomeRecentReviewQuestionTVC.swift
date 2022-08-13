//
//  HomeRecentReviewQuestionTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

class HomeRecentReviewQuestionTVC: BaseTVC {
    
    // MARK: Components
    private let recentCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .gray3
    }
    
    // MARK: - Properties
    private lazy var CVFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .zero
        $0.itemSize = CGSize.init(width: (screenWidth - 32) * 2 / 3, height: 153)
    }
    var recentReviewsDummyData: HomeRecentReviewResponseModel = [
        HomeRecentReviewResponseModelElement(id: 111, oneLineReview: "원라인리뷰..~", majorName: "어쩌구공학과", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구"), ReviewTagList(tagName: "뭘 배우나요?")], like: Like(isLiked: true, likeCount: 13)),
        HomeRecentReviewResponseModelElement(id: 111, oneLineReview: "난 자유롭고 싶어 지금 전투력 수치 111퍼입고싶은 옷 입고싶어최대40자자자자자자자자잦자자자자자자자자자자자자자자자자자자자자자자자자자자자자자자잦자", majorName: "전공멀로하쥐", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구"), ReviewTagList(tagName: "뭘 배우나요?")], like: Like(isLiked: true, likeCount: 13)),
        HomeRecentReviewResponseModelElement(id: 111, oneLineReview: "원라인리뷰..~", majorName: "이것은긴전공명엄청길어어어어어어어어어어어어어어어어어", createdAt: "2022-06-12T01:35:59.500Z", tagList: [], like: Like(isLiked: true, likeCount: 13)),
        HomeRecentReviewResponseModelElement(id: 111, oneLineReview: "원라인리뷰..~", majorName: "어쩌구공학과", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구"), ReviewTagList(tagName: "뭘 배우나요?")], like: Like(isLiked: true, likeCount: 13)),
        HomeRecentReviewResponseModelElement(id: 111, oneLineReview: "원라인리뷰..~", majorName: "어쩌구공학과", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구"), ReviewTagList(tagName: "뭘 배우나요?")], like: Like(isLiked: true, likeCount: 13)),
        HomeRecentReviewResponseModelElement(id: 111, oneLineReview: "원라인리뷰..~", majorName: "어쩌구공학과", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구"), ReviewTagList(tagName: "뭘 배우나요?")], like: Like(isLiked: true, likeCount: 13))]
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HomeRecentReviewQuestionTVC {
    private func configureUI() {
        addSubviews([recentCV])
        
        recentCV.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
