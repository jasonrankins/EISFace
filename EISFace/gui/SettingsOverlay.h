//
//  SettingsOverlay.h
//  EISFace
//
//  Created by Jason Rankins on 3/13/13.
//
//

#import <UIKit/UIKit.h>
#include "testApp.h"

@interface SettingsOverlay : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *ipTextField;
    IBOutlet UITextField *portTextField;
    IBOutlet UISwitch *meshToggle;
    IBOutlet UISwitch *consoleToggle;
    IBOutlet UIButton *resetButton;
    IBOutlet UIButton *settingsButton;
    IBOutlet UIView * overlay;
    //TODO: Add camera & flash selection options
	testApp *myApp;
}

@property (nonatomic, strong) UIView * overlay;

- (IBAction)openSettings:(id)sender;
- (IBAction)closeSettings:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end