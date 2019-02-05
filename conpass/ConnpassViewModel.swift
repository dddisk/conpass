import RxSwift
import RxCocoa
import UIKit

class ConnpassViewModel {
    let ascButton: Driver<Void>
    let descButton: Driver<Void>
    var searchButton: Driver<Void>
    let searchKeyword: Driver<String?>
    let connpassModel = ConnpassModel()
    let Keywords = BehaviorRelay<String>(value: "")
    var resultsfields = BehaviorRelay<[ConnpassStruct.Events]>(value: [])
//    var resultsfields: ConnpassStruct = ConnpassStruct(events: [])
    private let disposeBag = DisposeBag()
    //https://qiita.com/fumiyasac@github/items/90d1ebaa0cd8c4558d96
    init(searchKeyword: Driver<String?>,
         ascButton: Driver<Void>,
         descButton: Driver<Void>,
         searchButton: Driver<Void>) {

        self.searchKeyword = searchKeyword
        self.ascButton = ascButton
        self.descButton = descButton
        self.searchButton = searchButton

        self.ascButton.drive(onNext: { _ in
            let ascDate = self.resultsfields.value.sorted(by: {$0.startedAt < $1.startedAt})
            self.resultsfields.accept(ascDate)
        }).disposed(by: disposeBag)

        self.descButton.drive(onNext: { _ in
            let deskDate = self.resultsfields.value.sorted(by: {$1.startedAt < $0.startedAt})
            self.resultsfields.accept(deskDate)
        }).disposed(by: disposeBag)

        //https://qiita.com/mafmoff/items/7ffe707c2f3097b44297 値のアクセスはvalueを使う
        self.searchButton
            .flatMapLatest { _ in
                self.connpassModel.fetchEvent(keyword: self.Keywords.value)
                    .asDriver(onErrorJustReturn: [])
            }
            .drive(resultsfields)
            .disposed(by: disposeBag)

        self.searchKeyword.drive(onNext: { [weak self] keyword in
            self?.Keywords.accept(keyword!)
        }).disposed(by: disposeBag)

    }
}
