  //
  //  TaskBootcamp.swift
  //  SwiftConcurrencyBootcamp
  //
  //  Created by Ayoola Abimbola on 3/27/26.
  //

import SwiftUI

@Observable class TaskBootcampViewModel {
  var image: UIImage? = nil
  var image2: UIImage? = nil

  func fetchImage() async {
    do {
      guard let url = URL(string: "https://picsum.photos/1000") else { return }
      let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)

      await MainActor.run {
        self.image = UIImage(data: data)
      }

    } catch {
      print(error.localizedDescription)
    }
  }

  func fetchImage2() async {
    do {
      guard let url = URL(string: "https://picsum.photos/1000") else { return }
      let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)

      self.image2 = UIImage(data: data)
    } catch {
      print(error.localizedDescription)
    }
  }

}

struct TaskBootcamp: View {
  @State private var viewModel: TaskBootcampViewModel = TaskBootcampViewModel()

  var body: some View {
    VStack(spacing: 40) {
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
      }

      if let image2 = viewModel.image2 {
        Image(uiImage: image2)
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
      }
    }
    .onAppear {
      Task {
        try? await Task.sleep(nanoseconds: 4000000000)
        print(Thread.current)
        print(Task.currentPriority)
        await viewModel.fetchImage()
      }
      Task {
        await Task.yield()
        print(Thread.current)
        print(Task.currentPriority)
        await viewModel.fetchImage2()
      }
    }
  }
}

#Preview {
  TaskBootcamp()
}
