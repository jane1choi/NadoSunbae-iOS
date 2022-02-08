//
//  SelectMajorModalVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/10.
//

import UIKit

class SelectMajorModalVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completeBtn: NadoSunbaeBtn!
    @IBOutlet weak var selectMajorTV: UITableView!
    
    /// 진입된 버튼의 태그, 0: 본전공, 1: 본전공진입시기, 2: 제2전공, 3: 제2전공진입시기
    var enterdBtnTag = 0
    
    var startList = ["19-1", "19-2", "20-1", "20-2"]
    var majorList: [MajorInfoModel] = []
    var selectMajorDelegate: SendUpdateModalDelegate?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTV()
    }
    
    // MARK: Custom Method
    private func configureUI() {
        completeBtn.setTitleWithStyle(title: "선택 완료", size: 16, weight: .semiBold)
        completeBtn.isEnabled = false
        /// enterBtnTag에 맞춰서 타이틀, 데이터 변경
        titleLabel.text = { () -> String in
            switch enterdBtnTag {
            case 0:
                requestGetMajorList(univID: 1, filterType: "firstMajor")
                return "본전공"
            case 1:
                return "본전공 진입시기"
            case 2:
                requestGetMajorList(univID: 1, filterType: "secondMajor")
                return "제2전공"
            case 3:
                return "제2전공 진입시기"
            default:
                return ""
            }
        }()
    }
    
    private func setUpTV() {
        selectMajorTV.dataSource = self
        selectMajorTV.delegate = self
    }
    
    // MARK: IBAction
    @IBAction func tapCompleteBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        let sendData = { () -> String in
            switch self.enterdBtnTag {
            case 0, 2:
                return self.majorList[self.selectMajorTV.indexPathForSelectedRow?.row ?? 0]
            case 1, 3:
                return self.startList[self.selectMajorTV.indexPathForSelectedRow?.row ?? 0]
            default:
                return ""
            }
        }()
        selectMajorDelegate?.sendUpdate(data: sendData)
    }
    
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectMajorModalVC {
    
    /// 학과 정보 리스트 조회
    func requestGetMajorList(univID: Int, filterType: String) {
        PublicAPI.shared.getMajorListAPI(univID: univID, filterType: filterType) { networkResult in
            switch networkResult {
            case .success(let res):
                DispatchQueue.main.async {
                    if let data = res as? [MajorListData] {
                        for i in 0...data.count - 3 {
                            self.majorList.append(MajorInfoModel(majorID: data[i].majorID, majorName: data[i].majorName))
                        }
                        self.selectMajorTV.reloadData()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
