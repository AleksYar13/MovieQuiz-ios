import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    } 
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let randomRating = Float.random(in: 6...9)
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма \nбольше чем \(Int(randomRating))?"
            let correctAnswer = rating > randomRating
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}


// let question = "Рейтинг этого фильма болье 7?"
//
// private let questions: [QuizQuestion] = [
//    QuizQuestion(
//        image: "The Godfather",
//        text: question,
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Dark Knight",
//        text: question,
//        correctAnswer: true),
//    QuizQuestion(
//        image: "Kill Bill",
//        text: question,
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Avengers",
//        text: question,
//        correctAnswer: true),
//    QuizQuestion(
//        image: "Deadpool",
//        text: question,
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Green Knight",
//        text: question,
//        correctAnswer: true),
//    QuizQuestion(
//        image: "Old",
//        text: question,
//        correctAnswer: false),
//    QuizQuestion(
//        image: "The Ice Age Adventures of Buck Wild",
//        text: question,
//        correctAnswer: false),
//    QuizQuestion(
//        image: "Tesla",
//        text: question,
//        correctAnswer: false),
//    QuizQuestion(
//        image: "Vivarium",
//        text: question,
//        correctAnswer: false)
//]
//
