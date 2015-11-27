//
//  ViewController.swift
//  KeyboardTest
//
//  Created by Thomas Wehnert on 27.11.15.
//  Copyright © 2015 Thomas Wehnert. All rights reserved.
//

import UIKit

protocol AutoKeyboardScrollable {
    
    func willShowKeyboard(notification: NSNotification)
    func willHideKeyboard(notification: NSNotification)
    func registerNotification()
    func getContentScrollView() -> UIScrollView!
    
}

extension AutoKeyboardScrollable where Self: UIViewController {
    func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func willShowKeyboard(notification: NSNotification) {
        guard notification.userInfo != nil else { return }
        guard let scrollView = getContentScrollView() else { return }
        
        let userInfo = notification.userInfo
        let keyboardSize: CGSize = (userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size)!
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        
        scrollView.scrollEnabled = true
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        if !CGRectContainsPoint(aRect, self.view.frame.origin) {
            scrollView.scrollRectToVisible(self.view.frame, animated: true)
        }
    }
    
    func willHideKeyboard(notification: NSNotification) {
        guard let scrollView = getContentScrollView() else { return }
        
        let contentInset = UIEdgeInsetsZero;
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)
        scrollView.scrollEnabled = false
    }
}

class ViewController: UIViewController, AutoKeyboardScrollable {

    @IBOutlet weak var contentScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Protocol stuff
    func getContentScrollView() -> UIScrollView! {
        return contentScrollView
    }
    
//    func willShowKeyboard(notification: NSNotification) {
//        guard notification.userInfo != nil else { return }
//        guard let scrollView = getContentScrollView() else { return }
//        
//        let userInfo = notification.userInfo
//        let keyboardSize: CGSize = (userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size)!
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
//        
//        scrollView.scrollEnabled = true
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//        
//        var aRect: CGRect = self.view.frame
//        aRect.size.height -= keyboardSize.height
//        if !CGRectContainsPoint(aRect, self.view.frame.origin) {
//            scrollView.scrollRectToVisible(self.view.frame, animated: true)
//        }
//    }
//    
//    func willHideKeyboard(notification: NSNotification) {
//        guard let scrollView = getContentScrollView() else { return }
//        
//        let contentInset = UIEdgeInsetsZero;
//        
//        scrollView.contentInset = contentInset
//        scrollView.scrollIndicatorInsets = contentInset
//        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)
//        scrollView.scrollEnabled = false
//    }

}

