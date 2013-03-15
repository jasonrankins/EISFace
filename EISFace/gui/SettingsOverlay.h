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
    IBOutlet UIButton *resetButton;
    //TODO: Add camera & flash selection options
	testApp *myApp;
}

@property (nonatomic, strong) IBOutlet UIView * overlay;
@property (nonatomic, strong) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) IBOutlet UITextField *ipTextField;
@property (nonatomic, strong) IBOutlet UITextField *portTextField;
@property (nonatomic, strong) IBOutlet UISwitch *meshToggle;
@property (nonatomic, strong) IBOutlet UISwitch *consoleToggle;

- (IBAction)openSettings:(id)sender;
- (IBAction)closeSettings:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)switchToggled:(id)sender;
- (IBAction)reset:(id)sender;

@end