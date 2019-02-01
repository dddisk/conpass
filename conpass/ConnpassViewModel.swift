import RxSwift
import RxCocoa
import UIKit

struct ConnpassViewModelInput {
    let ascButton: Driver<Void>
    let descButton: Driver<Void>
//    let searchKeyword: Driver<String?>
}

class ConnpassViewModel {
    let ascButton: Driver<Void>
    let descButton: Driver<Void>
    let searchKeyword: Driver<String?>
    let Keywords = BehaviorRelay<String>(value: "")
    var resultsfields: ConnpassStruct = ConnpassStruct(events: [])
    //https://qiita.com/fumiyasac@github/items/90d1ebaa0cd8c4558d96
    init(searchKeyword: Driver<String?>,
         ascButton: Driver<Void>,
         descButton: Driver<Void>) {

        self.searchKeyword = searchKeyword
        self.ascButton = ascButton
        self.descButton = descButton

        self.ascButton.drive(onNext: { [weak self] in
            print("test1")
            self?.resultsfields.events.sort(by: {$0.startedAt < $1.startedAt})
        }).disposed(by: disposeBag)

        self.descButton.drive(onNext: { [weak self] in
            self?.resultsfields.events.sort(by: {$1.startedAt < $0.startedAt})
        }).disposed(by: disposeBag)

        self.searchKeyword.drive(onNext: { [weak self] keyword in
            self?.Keywords.accept(keyword!)
        }).disposed(by: disposeBag)

    }

    private let disposeBag = DisposeBag()
//    var ascButton: Driver<Bool>
//    var descButton: Driver<Bool>

    func setup(input: ConnpassViewModelInput) {

    }

    func setupSearchBar() {

    }
}
