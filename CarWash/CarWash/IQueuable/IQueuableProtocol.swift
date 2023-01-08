//
//  IQueuableProtocol.swift
//  CarWash
//
//  Created by jevania on 07/01/23.
//

import Foundation

protocol IQueuable {
    mutating func enqueue(value: CarModel) -> [CarModel] //adds value to queue and returns new queue
    mutating func dequeue() -> CarModel //removes item from queue, and returns the item removed
    func getQueue() -> [CarModel] //returns a list of all the items in the queue
    func size() -> Int //returns the number of items in the queue
}

class FIFOQueue: IQueuable {
    var queue: [CarModel]
    
    init() {
        self.queue = []
    }
    
    func enqueue(value: CarModel) -> [CarModel] {
        queue.append(value)
        return queue
    }
    
    func dequeue() -> CarModel {
        return queue.removeFirst()
    }
    
    func getQueue() -> [CarModel] {
        return queue
    }
    
    func size() -> Int {
        return queue.count
    }
}

class LIFOQueue: IQueuable {
    var queue: [CarModel]
    
    init() {
        self.queue = []
    }
    
    func enqueue(value: CarModel) -> [CarModel] {
        queue.append(value)
        return queue
    }
    
    func dequeue() -> CarModel {
        return queue.removeLast()
    }
    
    func getQueue() -> [CarModel] {
        return queue
    }
    
    func size() -> Int {
        return queue.count
    }
}
