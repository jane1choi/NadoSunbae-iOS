//
//  CommunityMainReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/23.
//

import UIKit
import ReactorKit

final class CommunityMainReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: represent user actions
    enum Action {
        case searchBtnDidTap
        case filterBtnDidTap
        case reloadCommunityTV(majorID: Int? = 0, type: PostFilterType, sort: String? = "recent", search: String? = "")
        case witeFloatingBtnDidTap
        case filterFilled
    }
    
    // MARK: represent state changes
    // Action과 State를 연결, Reactor Layer에만 존재
    enum Mutation {
        case setLoading(loading: Bool)
        case requestCommunityList(communityList: [PostListResModel])
        case setFilterBtnState(selected: Bool)
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var communityList: [PostListResModel] = []
        var majorList: [MajorInfoModel] = []
        var filterBtnSelected: Bool = false
    }
}

// MARK: - Reactor
extension CommunityMainReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .searchBtnDidTap:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .filterBtnDidTap:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .reloadCommunityTV(let majorID, let type, let sort, let search):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestCommunityList(majorID: majorID, type: type, sort: sort, search: search)
            ])
        case .witeFloatingBtnDidTap:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .filterFilled:
            return Observable.concat(Observable.just(.setFilterBtnState(selected: true)))
        }
    }
    
    /// reduce (Mutation -> State)
    /// 최종 State를 View로 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setLoading(let loading):
            newState.loading = loading
        case .requestCommunityList(let communityList):
            newState.communityList = communityList
        case .setFilterBtnState(let selected):
            newState.filterBtnSelected = selected
        }
        
        return newState
    }
}

// MARK: - Custom Methods
extension CommunityMainReactor {
    private func requestCommunityList(majorID: Int?, type: PostFilterType, sort: String?, search: String?) -> Observable<Mutation> {
        return Observable.create { observer in
            PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: majorID ?? 0, filter: type, sort: sort ?? "recent", search: search ?? "") { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? [PostListResModel] {
                        observer.onNext(Mutation.requestCommunityList(communityList: data))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    // ✅ TODO: Alert Display Protocol화 하기
                    if let _ = res as? String {
//                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        // ✅ TODO: updateAccessToken Protocol화 하기
//                        self.updateAccessToken { _ in
//                            self.setUpRequestData(sortType: .recent)
//                        }
                    }
                default:
                    // ✅ TODO: Alert Display Protocol화하기
//                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    observer.onNext(Mutation.setLoading(loading: false))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
