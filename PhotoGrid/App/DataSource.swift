//
//  DataSource.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import Foundation
import DifferenceKit

struct DataSource {
    let girlsNames: [String] = [
        "girls-1",
        "girls-2",
        "girls-3",
        "girls-4",
        "girls-5",
        "girls-6",
        "girls-7",
        "girls-8",
        "girls-9",
        "girls-10",
        "girls-11",
        "girls-12",
        "girls-13",
        "girls-14",
        "girls-15",
    ]
    
    let boysNames: [String] = [
        "boys-1",
        "boys-2",
        "boys-3",
        "boys-4",
        "boys-5",
        "boys-6",
        "boys-7",
        "boys-8",
        "boys-9",
        "boys-10",
        "boys-11",
        "boys-12",
        "boys-13",
        "boys-14",
        "boys-15",
        "boys-16",
        "boys-17",
        "boys-18",
        "boys-19",
        "boys-20",
    ]
    
    func buildData() -> [PersonCard]{
        let numberOfItems = 200
        var array = [PersonCard]()
        
        (0..<numberOfItems / 2).forEach { _ in
            array.append(.init(gender: .female, image: girlsNames[Int.random(in: 0..<girlsNames.count)], age: Int.random(in: 18..<65)))
        }
        
        (0..<numberOfItems / 2).forEach { _ in
            array.append(.init(gender: .male, image: boysNames[Int.random(in: 0..<boysNames.count)], age: Int.random(in: 18..<65)))
        }
        
        return array.shuffled()
    }
}

struct PersonCard: Differentiable {
    func isContentEqual(to source: PersonCard) -> Bool {
        return uuid == source.uuid
    }
    
    var differenceIdentifier: UUID {
        return uuid
    }
    
    enum Gender {
        case male
        case female
    }
    
    let uuid = UUID()
    let gender: Gender
    let image: String
    let age: Int
}
