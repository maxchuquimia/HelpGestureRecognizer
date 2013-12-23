//
//  MCViewController.h
//  HelpGestureRecognizer
//
//  Created by Max Chuquimia on 22/12/13.
//

#import <UIKit/UIKit.h>
#import "MCHelpGestureRecognizer.h"
@interface MCViewController : UIViewController <UIGestureRecognizerDelegate>
{
    MCHelpGestureRecognizer *helpRecognizer;
    IBOutlet UILabel *detectionLabel;
}
@end
