//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Александр Ярешко on 19.04.2023.
//


import UIKit

 protocol AlertPresenterDelegate: AnyObject {
     func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)

     func dismiss(animated flag: Bool, completion: (() -> Void)?)
 }
