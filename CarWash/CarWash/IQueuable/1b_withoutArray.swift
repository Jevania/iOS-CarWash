//
//  1b_withoutArray.swift
//  CarWash
//
//  Created by jevania on 07/01/23.
//

import Foundation

protocol IQueuableString2 {
  mutating func enqueue(value: String) -> [String] //adds value to queue and returns new queue
  mutating func dequeue() -> String //removes item from queue, and returns the item removed
  func getQueue() -> [String] //returns a list of all the items in the queue
  func getSize() -> Int //returns the number of items in the queue
}

class FIFOQueue_IQueuableString2: IQueuableString2 {
  private var head: Int
  private var tail: Int
  private var queue: [String]
  private var size: Int

  init(size: Int) {
    self.head = 0
    self.tail = 0
    self.queue = [String](repeating: "", count: size)
    self.size = size
  }

  func enqueue(value: String) -> [String] {
    if tail + 1 == size {
      //return "queue is full"
    }
    queue[tail] = value
    tail += 1

    return queue
  }

  func dequeue() -> String {
    if head == tail {
      return "queue is empty"
    }
    let value = queue[head]
    head += 1

    return value
  }

  func getQueue() -> [String] {
    return queue
  }

  func getSize() -> Int {
    return tail - head
  }
}

class LIFOQueue_IQueuableString2: IQueuableString2 {
  private var stack: [String]
  private var size: Int

  init(size: Int) {
    self.stack = [String](repeating: "", count: size)
    self.size = size
  }

  func enqueue(value: String) -> [String] {
    if stack.count == size {
      //return "stack is full"
    }
    stack.append(value)
    
    return stack
  }

  func dequeue() -> String {
    if stack.count == 0 {
      return "stack is empty"
    }
    return stack.removeLast()
  }

  func getQueue() -> [String] {
    return stack
  }

  func getSize() -> Int {
    return stack.count
  }
}
