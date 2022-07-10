//
//  MypageMainVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/16.
//

import UIKit

// MARK: - UITableDataSource
extension MypageMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseQuestionTVC.className, for: indexPath) as? BaseQuestionTVC else { return UITableViewCell() }
        cell.setData(data: self.questionList[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MypageMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
            questionDetailVC.hidesBottomBarWhenPushed = true
            questionDetailVC.questionType = .personal
            questionDetailVC.naviStyle = .push
            questionDetailVC.postID = self.questionList[indexPath.row].postID
        }
    }
}
