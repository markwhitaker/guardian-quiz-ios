//
//  QuizLoader.swift
//  Guardian Quiz
//
//  Created by Simon on 04/12/2020.
//

import Foundation

enum QuizLoadingError: Error {
  case httpError(statusCode: Int, message: String)
  case parsingError(underlyingError: Error)
  case unknownError(underlyingError: Error)
}

// The error type returned by the quiz server. Declaring it as a Codable struct
// so we can pass it to JSONDecoder.
struct QuizServerError: Codable {
  var errorMessage: String
}

enum ResultType<T, E> {
  case success(T)
  case failure(E)
}

typealias QuizResultType = ResultType<Quiz, QuizLoadingError>
typealias LoadQuizCallback = (QuizResultType) -> Void

func loadQuizFromURL(url: URL, callback: @escaping LoadQuizCallback) {
  let session = URLSession(configuration: .default)
  let dataTask = session.dataTask(with: url) { data, response, error in
    if let error = error {
      callback(.failure(.unknownError(underlyingError: error)))
    }

    else if
      let data = data,
      let response = response as? HTTPURLResponse
    {
      if response.statusCode == 200 {
        do {
          let quiz = try Quiz.fromJson(json: data)
          callback(.success(quiz))
        } catch {
          callback(.failure(.parsingError(underlyingError: error)))
        }
      } else {
        let jsonDecoder = JSONDecoder()
        do {
          let errorData = try jsonDecoder.decode(QuizServerError.self, from: data)
          callback(.failure(.httpError(statusCode: response.statusCode, message: errorData.errorMessage)))
        } catch {
          callback(.failure(.httpError(statusCode: response.statusCode, message: "Unknown error")))
        }
      }
    }
  }
  dataTask.resume()
}

func loadLatestQuiz(callback: @escaping LoadQuizCallback) {
  // https://saturday-quiz.herokuapp.com/swagger/index.html
  loadQuizFromURL(url: URL(string: "https://saturday-quiz.herokuapp.com/api/quiz")!, callback: callback)
}

func loadFixture() -> Quiz {
  let fixturePath = Bundle.main.path(forResource: "quiz", ofType: "json")

  do {
    let data = try Data(contentsOf: URL(fileURLWithPath: fixturePath!))
    return try Quiz.fromJson(json: data)
  } catch {
    return Quiz(title: "", date: Date(), questions: [])
  }
}
