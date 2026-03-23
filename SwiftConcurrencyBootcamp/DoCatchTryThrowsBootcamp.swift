//
//  DoTryCatchThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Ayoola Abimbola on 3/23/26.
//

import SwiftUI

// do-catch
// try
// throws

class DoCatchTryThrowsBootcampDataManager {
  let isActive: Bool = true

  func getTitle() -> (title: String?, error: Error?) {
    if isActive { return ("NEW TEXT", nil) }
    else { return (nil, URLError(.badURL)) }
  }

  func getTitle2() -> Result<String, Error> {
    if isActive { return .success("NEW TEXT") }
    else { return .failure(URLError(.appTransportSecurityRequiresSecureConnection)) }
  }

  func getTitle3() throws -> String {
//    if isActive { return "NEW TEXT" }
        if isActive { throw URLError(.badServerResponse) }
    else { throw URLError(.badServerResponse) }
  }

  func getTitle4() throws -> String {
    if isActive { return "FINAL TEXT" }
    else { throw URLError(.badServerResponse) }
  }

}

@Observable class DoCatchTryThrowsBootcampViewModel {
  var text: String = "Starting Text"

  let manager = DoCatchTryThrowsBootcampDataManager()

  func fetchTitle() {
    /*
     let returnValue = manager.getTitle()

     if let newTitle = returnValue.title {
     self.text = newTitle
     } else if let error = returnValue.error {
     self.text = error.localizedDescription
     }
     */

    /*
     let result = manager.getTitle2()

     switch result {
     case .success(let newTitle):
     self.text = newTitle
     case .failure(let error):
     self.text = error.localizedDescription
     }
     */

    /*
     do {
     let newTitle = try manager.getTitle3()
     self.text = newTitle

     let finalTitle = try manager.getTitle4()
     self.text = finalTitle
     //    } catch let error {
     } catch {
     self.text = error.localizedDescription
     }
     */

    /*
    if let newTitle = try? manager.getTitle3() {
      self.text = newTitle
    }
    */

    /* Force Unwrap is never recommended
     let newTitle = try! manager.getTitle3()
     self.text = newTitle
     */

    do {
      if let newTitle = try? manager.getTitle3() {
        self.text = newTitle
      }

      let finalTitle = try manager.getTitle4()
      self.text = finalTitle
      //    } catch let error {
    } catch {
      self.text = error.localizedDescription
    }
  }
}

struct DoCatchTryThrowsBootcamp: View {
  @State private var doCatchTryThrowsBootcampViewModel = DoCatchTryThrowsBootcampViewModel()

  var body: some View {
    Text(doCatchTryThrowsBootcampViewModel.text)
      .frame(width: 300, height: 300)
      .background(.green)
      .onTapGesture {
        doCatchTryThrowsBootcampViewModel.fetchTitle()
      }

  }
}

#Preview {
  DoCatchTryThrowsBootcamp()
}
