import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    final class MovieQuizViewController: UIViewController,
                                         QuestionFactoryDelegate{
        
        @IBOutlet private var counterLabel: UILabel!
        @IBOutlet private var imageView: UIImageView!
        @IBOutlet private var textLabel: UILabel!
        @IBOutlet private var yesButton: UIButton!
        @IBOutlet private var noButton: UIButton!
        
        private var currentQuestionIndex: Int = 0
        private var correctAnswers: Int = 0
        private let questionsAmount: Int = 10
        private var questionFactory: QuestionFactoryProtocol?
        private var currentQuestion: QuizQuestion?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 20
            
            questionFactory = QuestionFactory(delegate: self)
            questionFactory?.requestNextQuestion()
        }
        // MARK: - QuestionFactoryDelegate
        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
        }
        
        private func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        }
        
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            
        }
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
        private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
        private func showAnswerResult(isCorrect: Bool) {
            yesButton.isEnabled = false
            noButton.isEnabled = false
            if isCorrect {
                correctAnswers += 1
            }
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
                self.imageView.layer.borderWidth = 0
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
            }
        }
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionsAmount - 1 {
                let text = correctAnswers == questionsAmount ?
                "Поздравляем, Вы ответили на 10 из 10!" :
                "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
                let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")
                show(quiz: viewModel)
            } else {
                currentQuestionIndex += 1
                questionFactory?.requestNextQuestion()
            }
        }
        
        private func show (quiz result: QuizResultsViewModel) {
             let alertViewModel = AlertModel(title: result.title,
                                             message: result.text,
                                             buttontext: result.buttonText,
                                             completion: { [weak self] _ in
                 guard let self = self else { return }
                 self.currentQuestionIndex = 0
                 self.correctAnswers = 0                           
                 self.questionFactory?.requestNextQuestion()
             })

             let alert = AlertPresenter()
             alert.present(view: self, alert: alertViewModel)
         }
    }
}
