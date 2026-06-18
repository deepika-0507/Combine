//: A UIKit based Playground for presenting user interface
  
//import UIKit
import PlaygroundSupport
import SwiftUI
import Combine

// creating publishers from an array
let age: Publishers.Sequence<[String?], Never> = ["1", "2", "3", "4", nil].publisher
let names: Publishers.Sequence<[String?], Never> = ["a", "b", "c", "d", "e"].publisher

enum Errors: Error {
    case emptyData
    
    var message: String {
        switch self {
        case .emptyData:
            return "Data is empty"
        }
    }
}

func validate(name: String?, age: String?) throws -> String {
    guard let name, let age else {
        throw Errors.emptyData
    }
    return "\(name) and \(age)"
}

//Combining them into 1
let publisher = names
    .zip(age) // map index by index if index are not equal it will map till it is possible
//    .filter({ $0 != nil && $1 != nil }) // removes the nil values
    .tryMap({ try validate(name: $0, age: $1) })
    .sink(receiveCompletion: { result in // handle errors here
        switch result {
        case .finished:
            print("Done")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }, receiveValue: { message in
        print(message)
    })

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello")
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

PlaygroundPage.current.setLiveView(ContentView())
