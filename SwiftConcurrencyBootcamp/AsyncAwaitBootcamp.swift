//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Ayoola Abimbola on 3/26/26.
//

import SwiftUI

@Observable class AsyncAwaitBootcampViewModel {

  @ObservationIgnored var titleCount: Int = 0
  var dataArray: [String] = []

  func addTitle() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      let title = "Title1 \(Thread.current)"
      self.dataArray.append(title)
    }
  }

  func addTitle2() {
    DispatchQueue.global().asyncAfter(deadline: .now() + 10) {
      let title = "Title2 \(Thread.current)"

      DispatchQueue.main.async {
        self.dataArray.append(title)
      }
    }
  }

  func addAuthor1() async {
    let author1 = "Author 1 \(Thread.current)"
    self.dataArray.append(author1)

    try? await Task.sleep(nanoseconds: 5000000000)

    let author2 = "Author 2 \(Thread.current)"
    await MainActor.run {
      self.dataArray.append(author2)

      let author3 = "Author 3 \(Thread.current)"
      self.dataArray.append(author3)
    }

    await addSomething()
  }

  func addSomething() async {
    try? await Task.sleep(nanoseconds: 2000000000)

    let someThing1 = "Something 1: \(Thread.current)"

    await MainActor.run {
      self.dataArray.append(someThing1)

      let someThing2 = "Something 2: \(Thread.current)"
      self.dataArray.append(someThing2)
    }
  }

}

struct AsyncAwaitBootcamp: View {
  @State private var viewModel = AsyncAwaitBootcampViewModel()

  var body: some View {
    List(viewModel.dataArray, id: \.self) { item in
      Text(item)
    }
    .onAppear {
//      viewModel.addTitle()
//      viewModel.addTitle2()

      Task {
        await viewModel.addAuthor1()
      }
    }

  }
}

#Preview {
  AsyncAwaitBootcamp()
}
