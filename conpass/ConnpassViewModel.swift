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
        self.resultsfields = self.connpassModel.resultsfields

        //https://qiita.com/mafmoff/items/7ffe707c2f3097b44297 値のアクセスはvalueを使う
        self.searchButton.drive(onNext: { [weak self] in
            self?.connpassModel.fetchEvent(keyword: self!.Keywords.value)
                .subscribe(
                    onSuccess: {[weak self] resultsfields in
                        self?.resultsfields.accept(resultsfields)
                    },
                    onError: { error in
                        print(error)
                    }
            )
        }).disposed(by: disposeBag)

        self.searchKeyword.drive(onNext: { [weak self] keyword in
            self?.Keywords.accept(keyword!)
        }).disposed(by: disposeBag)

    }
}
