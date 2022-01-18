//
//  MypageMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class MypageMainVC: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: UIView! {
        didSet {
            navView.addShadow(offset: CGSize(width: 0, height: 4), color: .shadowDefault, opacity: 1, radius: 16)
        }
    }
    @IBOutlet weak var navTitleBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var userStateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var likeListView: UIView!
    @IBOutlet weak var questionTV: UITableView!
    @IBOutlet weak var questionTVHeight: NSLayoutConstraint!
    @IBOutlet weak var questionEmptyView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var firstMajorLabel: UILabel!
    @IBOutlet weak var secondMajorLabel: UILabel!
    
    // MARK: Properties
    var userInfo = MypageUserInfoModel()
    
    var questionList = [
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다ㅏㅏㅏㅏ", nickName: "윈터내거", writeTime: "2022-01-18T19:00:42.040Z", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", nickName: "윈터내거", writeTime: "2022-01-18T19:20:42.040Z", commentCount: 2, likeCount: 5)
    ]
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTV()
        registerCell()
    }
    
    // MARK: @IBAction
    @IBAction func goMypageUser(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: MypageUserVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageUserVC.className) as? MypageUserVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapEditProfileBtn(_ sender: Any) {
        /// 1순위!
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
    @IBAction func tapSettingBtn(_ sender: Any) {
        /// 4순위댱
    }
    
    @IBAction func tapLikeListBtn(_ sender: Any) {
        /// 4순위
    }
    
    @IBAction func tapSortBtn(_ sender: Any) {
        /// 3-4순위`
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let latestAction = UIAlertAction(title: "최신순", style: .default, handler: nil)
        let moreLikeAction = UIAlertAction(title: "좋아요순", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [latestAction, moreLikeAction, cancelAction].forEach { action in
            optionMenu.addAction(action)
        }
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: - UI
extension MypageMainVC {
    private func configureUI() {
        profileView.makeRounded(cornerRadius: 8.adjusted)
        likeListView.makeRounded(cornerRadius: 8.adjusted)
        questionEmptyView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.makeRounded(cornerRadius: 8.adjusted)
        questionTV.removeSeparatorsOfEmptyCellsAndLastCell()
        
        nickNameLabel.text = userInfo.nickname
        firstMajorLabel.text = "\(userInfo.firstMajorName) \(userInfo.firstMajorStart)"
        secondMajorLabel.text = "\(userInfo.secondMajorName) \(userInfo.secondMajorStart)"
        
        DispatchQueue.main.async {
            self.questionTVHeight.constant = self.questionTV.contentSize.height
            self.navTitleBottomSpace.constant = 26.adjustedH
            self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
            self.questionTV.isHidden = self.questionList.isEmpty ? true : false
            if self.userInfo.isOnQuestion {
                self.userStateViewHeight.constant = 0
            } else {
                self.userStateViewHeight.constant = 32.adjusted
            }
        }
    }
}

// MARK: - Custom Methods
extension MypageMainVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        questionTV.register(MypageQuestionTVC.self, forCellReuseIdentifier: MypageQuestionTVC.className)
    }
    
    private func setUpTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
    }
}

// MARK: - Network
extension MypageMainVC {
    private func getUserInfo() {
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJrdTJAa29yZWEuYWMua3IiLCJuaWNrbmFtZSI6Imt1MiIsImZpcmViYXNlSWQiOiJOT1ZDYktEUUlEY3IybmJsam9ZazhSSnJ0NTUyIiwiaWF0IjoxNjQyMzI5OTMwLCJleHAiOjE2NDQ5MjE5MzAsImlzcyI6Im5hZG9TdW5iYWUifQ.tiblhyT4Y9-DDH1KTwIm37wevbChJ-R8-ECSb3QpZUI"
        
        MypageAPI.shared.getUserInfo(userID: 1, accessToken: accessToken, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageUserInfoModel {
                    self.userInfo = data
                    self.configureUI()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해 데이터를 불러올 수 없습니다. 다시 시도해 주세요.")
            }
        })
    }
}
