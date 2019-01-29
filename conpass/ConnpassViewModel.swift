import RxSwift
import RxCocoa
import UIKit

struct ConnpassViewModelInput {
    let ascButton: Driver<Void>
    let descButton: Driver<Void>
}

class ConnpassViewModel {

    var resultsfields: ConnpassStruct = ConnpassStruct(events: [])

    private let disposeBag = DisposeBag()
//    var ascButton: Driver<Bool>
//    var descButton: Driver<Bool>
    func setup(input: ConnpassViewModelInput) {

        input.ascButton.drive(onNext: { [weak self] in
        print("test1")
        self?.resultsfields.events.sort(by: {$0.startedAt < $1.startedAt})
        }).disposed(by: disposeBag)

        input.descButton.drive(onNext: { [weak self] in
        self?.resultsfields.events.sort(by: {$1.startedAt < $0.startedAt})
        }).disposed(by: disposeBag)

    }
}
