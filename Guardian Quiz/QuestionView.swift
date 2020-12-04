//
//  QuestionView.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import SwiftUI

let titlePadding = EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)

struct QuestionView: View {
  var question: Question
  var showAnswer: Bool
  var scaleFactor: CGFloat = 1.0

  var body: some View {
    let headerFont: Font = scaleFactor < 1.1 ? .title3 : Font.system(size: 16 * scaleFactor)
    let bodyFont: Font = scaleFactor < 1.1 ? .title : Font.system(size: 24 * scaleFactor)

    VStack(alignment: .leading, spacing: 20 * scaleFactor) {
      Text("Question \(question.number)".appending(question.type == .whatLinks ? ": What Links?" : "")).font(headerFont)
      if question.type == .whatLinks {
        VStack(alignment: .leading, spacing: 6 * scaleFactor) {
          ForEach(question.whatLinksOptions) { opt in
            HStack(spacing: 12 * scaleFactor) {
              Image(systemName:"circle.fill").font(.system(size: 12 * scaleFactor))
              Text(opt.value).font(bodyFont)
            }
          }
        }
      } else {
        Text(question.question)
          .font(bodyFont)
      }
      if showAnswer {
        Text(question.answer).font(bodyFont).foregroundColor(.accentColor)
      }
    }
  }
}

struct QuestionView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionView(question: Question(number: 1, type: .normal, question: "Foo Bar Baz Wibble jidsji dsji djsi dsji djsi djsi disj Boom", answer: "Bar"), showAnswer: true)
    QuestionView(question: Question(number: 1, type: .whatLinks, question: "Foo; Bar; Baz; Wibble jidsji dsji djsi dsji djsi djsi disj Boom", answer: "Bar"), showAnswer: true)
  }
}
