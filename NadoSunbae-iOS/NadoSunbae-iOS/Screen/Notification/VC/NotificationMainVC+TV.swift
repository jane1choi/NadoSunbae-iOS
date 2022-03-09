//
//  NotificationMainVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/17.
//

import UIKit

// MARK: - UITableViewDataSource
extension NotificationMainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTVC.className, for: indexPath) as? NotificationTVC else { return UITableViewCell() }
        
        cell.setData(data: notificationList[indexPath.section])
        cell.deleteBtn.tag = indexPath.section
        cell.deleteBtn.addTarget(self, action: #selector(self.removeCell), for: .touchUpInside)
        
        return cell
    }
    
    @objc func removeCell(_ sender: UIButton) {
        self.deleteNoti(notiID: self.notificationList[sender.tag].notificationID)
    }
}

// MARK: - UITableViewDelegate
extension NotificationMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch notificationList[indexPath.section].notificationTypeID.getNotiType() {
        case .writtenInfo:
            guard let infoDetailVC = UIStoryboard(name: Identifiers.InfoSB, bundle: nil).instantiateViewController(identifier: InfoDetailVC.className) as? InfoDetailVC else { return }
            
            infoDetailVC.postID = notificationList[indexPath.section].postID
            infoDetailVC.hidesBottomBarWhenPushed = true
            
            readNoti(notiID: notificationList[indexPath.section].notificationID)
            self.navigationController?.pushViewController(infoDetailVC, animated: true)
            
        case .writtenQuestion:
            guard let groupChatVC = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil).instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
            
            groupChatVC.questionType = notificationList[indexPath.section].isQuestionToPerson ? .personal : .group
            groupChatVC.naviStyle = .push
            groupChatVC.postID = notificationList[indexPath.section].postID
            groupChatVC.hidesBottomBarWhenPushed = true

            readNoti(notiID: notificationList[indexPath.section].notificationID)
            self.navigationController?.pushViewController(groupChatVC, animated: true)
            
        case .answerInfo:
            guard let infoDetailVC = UIStoryboard(name: Identifiers.InfoSB, bundle: nil).instantiateViewController(identifier: InfoDetailVC.className) as? InfoDetailVC else { return }
            
            infoDetailVC.postID = notificationList[indexPath.section].postID
            infoDetailVC.hidesBottomBarWhenPushed = true
            
            readNoti(notiID: notificationList[indexPath.section].notificationID)
            self.navigationController?.pushViewController(infoDetailVC, animated: true)
            
        case .answerQuestion:
            guard let groupChatVC = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil).instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
            
            groupChatVC.questionType = notificationList[indexPath.section].isQuestionToPerson ? .personal : .group
            groupChatVC.naviStyle = .push
            groupChatVC.postID = notificationList[indexPath.section].postID
            groupChatVC.hidesBottomBarWhenPushed = true
            
            readNoti(notiID: notificationList[indexPath.section].notificationID)
            self.navigationController?.pushViewController(groupChatVC, animated: true)
            
        case .mypageQuestion:
            guard let groupChatVC = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil).instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
            
            groupChatVC.questionType = .personal
            groupChatVC.naviStyle = .push
            groupChatVC.postID = notificationList[indexPath.section].postID
            groupChatVC.hidesBottomBarWhenPushed = true
            
            readNoti(notiID: notificationList[indexPath.section].notificationID)
            self.navigationController?.pushViewController(groupChatVC, animated: true)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return emptyViewForTV
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return emptyViewForTV
    }
}
