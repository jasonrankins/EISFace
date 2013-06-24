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
@property (nonatomic, strong) IBOutlet UITextField *ipTextField;
@property (nonatomic, strong) IBOutlet UITextField *portTextField;
@property (nonatomic, strong) IBOutlet UITextField *iterationsTextField;
@property (nonatomic, strong) IBOutlet UITextField *attemptsTextField;
@property (nonatomic, strong) IBOutlet UITextField *scaleTextField;
@property (nonatomic, strong) IBOutlet UISwitch *meshToggle;
@property (nonatomic, strong) IBOutlet UISwitch *consoleToggle;
@property (nonatomic, strong) IBOutlet UILabel *fpsLabel;
@property (nonatomic, strong) IBOutlet UILabel *trackingStatus;
@property (nonatomic, strong) IBOutlet UILabel *eyebrows;
@property (nonatomic, strong) IBOutlet UILabel *eyes;
@property (nonatomic, strong) IBOutlet UILabel *nostrils;
@property (nonatomic, strong) IBOutlet UILabel *mouth;
@property (nonatomic, strong) IBOutlet UILabel *jaw;
@property (nonatomic, strong) IBOutlet UILabel *position;
@property (nonatomic, strong) IBOutlet UILabel *orientation;
@property (nonatomic, strong) IBOutlet UILabel *scale;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)switchToggled:(id)sender;
- (IBAction)reset:(id)sender;

@end