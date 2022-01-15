//
//  WriteQuestionVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/14.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class WriteQuestionVC: UIViewController {
    
    // MARK: Properties
    private let questionScrollView = UIScrollView()
    private let contentView = UIView()
    private let disposeBag = DisposeBag()
    private var questionTextViewLineCount: Int = 1
    private let questionWriteNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .dismissWithNadoBtn)
        $0.configureTitleLabel(title: "1:1 질문 작성")
    }
    
    private let questionTitleTextField = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.placeholder = "질문 제목을 입력하세요."
        $0.textColor = .mainDefault
        $0.font = .PretendardSB(size: 24.0)
    }
    
    private let textHighlightView = UIView().then {
        $0.backgroundColor = .gray0
    }
    
    private let contentHeaderLabel = UILabel().then {
        $0.text = "내용"
        $0.textColor = .black
        $0.font = .PretendardM(size: 16.0)
    }
    
    private let questionWriteTextView = NadoTextView().then {
        $0.setDefaultStyle(placeholderText: "선배에게 1:1 질문을 남겨보세요.\n선배가 답변해 줄 거에요!")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        configureUI()
        setTextViewDelegate()
        setTapBtnAction()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
}

// MARK: - UI
extension WriteQuestionVC {
    
    /// UI 구성하는 메서드
    private func configureUI() {
        view.addSubviews([questionWriteNaviBar, questionScrollView])
        questionScrollView.addSubview(contentView)
        contentView.addSubviews([questionTitleTextField, textHighlightView, contentHeaderLabel, questionWriteTextView])
        
        questionWriteNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        questionScrollView.snp.makeConstraints {
            $0.top.equalTo(questionWriteNaviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        questionTitleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        textHighlightView.snp.makeConstraints {
            $0.top.equalTo(questionTitleTextField.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(questionTitleTextField)
            $0.height.equalTo(1)
        }
        
        contentHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(textHighlightView.snp.bottom).offset(72)
            $0.leading.equalTo(textHighlightView)
        }
        
        questionWriteTextView.snp.makeConstraints {
            $0.top.equalTo(contentHeaderLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(questionTitleTextField)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-102)
        }
        
        setHighlightViewState(textField: questionTitleTextField, highlightView: textHighlightView)
    }
}

// MARK: - Custom Method
extension WriteQuestionVC {
    
    /// textView delegate 설정하는 메서드
    private func setTextViewDelegate() {
        questionWriteTextView.delegate = self
    }
    
    /// textField가 채워져 있는지에 따라 highlightView 상태 변경하는 메서드
    private func setHighlightViewState(textField: UITextField, highlightView: UIView) {
        textField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] changedText in
                if self?.questionTitleTextField.text?.isEmpty == true {
                    self?.textHighlightView.backgroundColor = .gray0
                } else {
                    self?.textHighlightView.backgroundColor = .black
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// btn Action set 메서드
    private func setTapBtnAction() {
        questionWriteNaviBar.rightActivateBtn.press {
            print("press")
            // TODO: Alert 띄우기
        }
        
        questionWriteNaviBar.dismissBtn.press {
            print("dismiss")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// textView의 상태에 따라 스크롤뷰를 Up, Down 하는 메서드
    private func scollByTextViewState(textView: UITextView) {
        var contentOffsetY = questionScrollView.contentOffset.y
        var isLineAdded = true
        
        if questionTextViewLineCount != textView.numberOfLines() {
            
            if questionTextViewLineCount > textView.numberOfLines() {
                isLineAdded = false
            } else {
                isLineAdded = true
            }
            
            if  isLineAdded && textView.numberOfLines() > 8 && questionScrollView.contentOffset.y < 243 {
                contentOffsetY += 38
                questionScrollView.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: true)
                
            } else if !isLineAdded && questionTextViewLineCount < 14 && questionScrollView.contentOffset.y > 0 {
                
                if contentOffsetY - 38 > 0 {
                    contentOffsetY -= 38
                    questionScrollView.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: true)
                } else {
                    contentOffsetY = 0
                    questionScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
            
        }
        questionTextViewLineCount = textView.numberOfLines()
    }
}

// MARK: - UITextViewDelegate
extension WriteQuestionVC: UITextViewDelegate {
    
    /// scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async() {
            scrollView.scrollIndicators.vertical?.backgroundColor = .scrollMint
        }
    }
    
    /// textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray2 {
            textView.text = nil
            textView.textColor = .mainText
        }
    }
    
    /// textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        scollByTextViewState(textView: textView)
    }
    
    /// textViewDidEndEditing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "선배에게 1:1 질문을 남겨보세요.\n선배가 답변해 줄 거에요!"
            textView.textColor = .gray2
        }
    }
}

// MARK: - Keyboard
extension WriteQuestionVC {
    
    /// Keyboard Observer add 메서드
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Keyboard Observer remove 메서드
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// keyboardWillHide
    @objc
    func keyboardWillHide(notification: Notification) {
        questionScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
