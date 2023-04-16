import Foundation

private let question: String = "Рейтинг этого фильма больше чем 6?"

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: question,
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: question,
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: question,
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: question,
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: question,
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: question,
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: question,
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: question,
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: question,
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: question,
            correctAnswer: false)
    ]
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}

