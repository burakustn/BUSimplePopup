//
//  BUSimplePopupView.swift
//  BUSimplePopups
//
//  Created by Burak Üstün on 08/06/17.
//  Copyright © 2017 Burak Üstün. All rights reserved.
//

import UIKit

let kLNRPopupViewMinimumPadding: CGFloat = 15.0
let kPopupMinimumWidth : CGFloat = 300.0
let kPopupCornerRadius: CGFloat = 15.0
let kPopupMinLabelHeight: CGFloat = 30.0
let kPopupSeperatorPadding:CGFloat = 7.0



public class BUSimplePopupView: UIView, UIGestureRecognizerDelegate {

    public var isDisplayed: Bool = false
    
    public var Popup: BUSimplePopup
    
    /**
     *  Initialize the Popup
    */
    init(Popup: BUSimplePopup, PopupManager : BUSimplePopupManager){
        self.Popup = Popup
        self.PopupManager = PopupManager
        
        let screenWidth: CGFloat = (UIApplication.shared.keyWindow?.bounds.width)!
        let screenHeight: CGFloat = (UIApplication.shared.keyWindow?.bounds.height)!
        let padding: CGFloat = kLNRPopupViewMinimumPadding
        let PopupWidth:CGFloat = kPopupMinimumWidth
        let cornerRadius:CGFloat = kPopupCornerRadius
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .clear
        
        let backView:UIView = UIView.init(frame: CGRect.zero)
        backView.alpha = PopupManager.PopupBackgroundAlpha
        backView.backgroundColor = PopupManager.PopupsBackgroundColor
        self.addSubview(backView)
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        self.PopupImage.frame = CGRect.init(x: (PopupWidth - PopupManager.PopupImageWidth)/2, y: padding,
                                                   width: PopupManager.PopupImageWidth, height: PopupManager.PopupImageHeight)
        self.PopupImage.contentMode = .scaleAspectFill
        self.PopupImage.image = Popup.image
        self.addSubview(self.PopupImage)
        
        if(self.PopupImage.image == nil){
             self.PopupImage.frame = CGRect.zero
        }
        
        let titleWidth:CGFloat = PopupWidth - 2 * padding
        let titleHeight:CGFloat = heightForLabel(text: Popup.title!, font: self.PopupTitle.font, width: titleWidth) > kPopupMinLabelHeight ?
            heightForLabel(text: Popup.title!, font: self.PopupTitle.font, width: titleWidth) : kPopupMinLabelHeight
        self.PopupTitle.frame = CGRect.init(x: padding, y: self.PopupImage.frame.size.height + self.PopupImage.frame.origin.y + kPopupSeperatorPadding,
                                                   width: titleWidth, height: titleHeight)
        self.layoutSubviews()
        self.PopupTitle.numberOfLines = 0
        self.PopupTitle.lineBreakMode = .byWordWrapping
        self.PopupTitle.font = PopupManager.PopupsTitleFont
        self.PopupTitle.text =  Popup.title!
        self.PopupTitle.textAlignment = PopupManager.PopupsTitleTextAligment
        self.PopupTitle.textColor = PopupManager.PopupsTitleTextColor
        self.addSubview(self.PopupTitle)
        
        if(self.PopupTitle.text == nil || self.PopupTitle.text == ""){
            self.PopupTitle.frame = CGRect.init(x: self.PopupTitle.frame.origin.x, y: self.PopupTitle.frame.origin.y, width: self.PopupTitle.frame.size.width, height: 0)
        }
        
        let bodyWidth:CGFloat = PopupWidth - 2 * padding
        let bodyHeight:CGFloat = heightForLabel(text: Popup.body!, font: self.PopupBody.font, width: titleWidth)
        self.PopupBody.frame = CGRect.init(x: padding, y: self.PopupTitle.frame.size.height + self.PopupTitle.frame.origin.y + kPopupSeperatorPadding,
                                                   width: bodyWidth, height: bodyHeight)
        self.layoutSubviews()
        self.PopupBody.numberOfLines = 0
        self.PopupBody.lineBreakMode = .byWordWrapping
        self.PopupBody.font = PopupManager.PopupsBodyFont
        self.PopupBody.text =  Popup.body!
        self.PopupBody.textAlignment = PopupManager.PopupsTitleTextAligment
        self.PopupBody.textColor = PopupManager.PopupsBodyTextColor
        self.PopupBody.sizeToFit()
        self.addSubview(self.PopupBody)
        
        self.frame = CGRect.init(x: (screenWidth - PopupWidth)/2, y: (screenHeight - self.heightforPopup())/2,
                                              width: PopupWidth, height: self.heightforPopup())
        backView.frame = CGRect.init(x: 0, y: 0, width: PopupWidth, height: self.heightforPopup())
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BUSimplePopupView.handleTap(tapGestureRecognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     *  Dismiss Popup
    */
    public func dismissWithCompletion(_ completion: BUSimplePopupCompletionBlock?) -> Bool {
        return PopupManager.dismissPopupView(PopupView: self, dismissAnimationCompletion: completion)
    }
    
    
    /**
     *  Get the height of Label
    */
    private func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
    }
    
    /**
     *  Get the height of Popup
     */
    private func heightforPopup() -> CGFloat{
        let padding:CGFloat = kLNRPopupViewMinimumPadding
        var height:CGFloat = padding
       
        
        if(PopupImage.image != nil){
            height += self.PopupImage.frame.height + padding
        }
        
        if(PopupTitle.text != nil){
            height += self.PopupTitle.frame.height + padding
        }
        
        if(PopupBody.text != nil){
            height += self.PopupBody.frame.height + padding
        }
        
        return height
    }
    
    // MARK : Private
    
    private let PopupManager: BUSimplePopupManager!
    
    private let PopupImage:UIImageView = UIImageView()
    
    private let PopupTitle:UILabel = UILabel()
    
    private let PopupBody:UILabel = UILabel()
    
    //MARK: Tap Recognition
    
    func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == UIGestureRecognizerState.ended {
            let _ = dismissWithCompletion(nil)
            }
    }
}


