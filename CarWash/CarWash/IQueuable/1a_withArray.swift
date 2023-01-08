//
//  1a_withArray.swift
//  CarWash
//
//  Created by jevania on 07/01/23.
//

import Foundation

protocol IQueuableString1 {
  mutating func enqueue(value: String) -> [String] //adds value to queue and returns new queue
  mutating func dequeue() -> String //removes item from queue, and returns the item removed
  func getQueue() -> [String] //returns a list of all the items in the queue
  func size() -> Int //returns the number of items in the queue
}

class FIFOQueue_IQueuableString: IQueuableString1 {
  var queue: [String]

  init() {
    self.queue = []
  }

  func enqueue(value: String) -> [String] {
    queue.append(value)
    return queue
  }

  func dequeue() -> String {
    return queue.removeFirst()
  }

  func getQueue() -> [String] {
    return queue
  }

  func size() -> Int {
    return queue.count
  }
}

class LIFOQueue_IQueuableString: IQueuableString1 {
  var queue: [String]

  init() {
    self.queue = []
  }

  func enqueue(value: String) -> [String] {
    queue.append(value)
    return queue
  }

  func dequeue() -> String {
    return queue.removeLast()
  }

  func getQueue() -> [String] {
    return queue
  }

  func size() -> Int {
    return queue.count
  }
}

