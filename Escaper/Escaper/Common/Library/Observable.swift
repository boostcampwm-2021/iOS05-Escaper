//
//  Observable.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import Foundation

class Observable<T> {
    struct Observer<T> {
        weak var observer: AnyObject?
        let block: (T) -> Void
    }

    private var observers = [Observer<T>]()
    var value: T {
        didSet {
            self.notifyObservers()
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func observe(on observer: AnyObject, observerBlock: @escaping (T) -> Void) {
        self.observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
    }

    func remove(observer: AnyObject) {
        self.observers = observers.filter { $0.observer !== observer }
    }
}

private extension Observable {
    func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async {
                observer.block(self.value)
            }
        }
    }
}
