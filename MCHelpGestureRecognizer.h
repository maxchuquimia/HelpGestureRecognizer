//
//  MCHelpGestureRecognizer.h
//  HelpGestureRecognizer
//
//  Created by Max Chuquimia on 22/12/13.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MCHelpGestureRecognizer : UIGestureRecognizer
{
    NSMutableArray *curvePoints;
    BOOL listenForPoint;
    NSTimer *timer;
}

@end
