//
//  CustomSegue.swift
//  twitterSearch
//
//  Created by vicente rodriguez on 4/4/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVc = self.sourceViewController
        let destinationVc = self.destinationViewController
        
        sourceVc.view.addSubview(destinationVc.view)
        
        destinationVc.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { 
            destinationVc.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }) { (finished) in
                
                destinationVc.view.removeFromSuperview()
                
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
                
                dispatch_after(time, dispatch_get_main_queue(), {
                    sourceVc.presentViewController(destinationVc, animated: false, completion: nil)
                })
        }
    }
}
