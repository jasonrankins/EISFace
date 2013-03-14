//
//  SettingsOverlay.m
//  EISFace
//
//  Created by Jason Rankins on 3/13/13.
//
//

#import "SettingsOverlay.h"

@interface SettingsOverlay ()

@end

@implementation SettingsOverlay
@synthesize overlay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    myApp = (testApp*)ofGetAppPtr();
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSettings:(id)sender {
    overlay.hidden = NO;
    settingsButton.hidden = YES;
    myApp->bPaused = true;
}

- (IBAction)closeSettings:(id)sender {
    overlay.hidden = YES;
    settingsButton.hidden = NO;
    myApp->bPaused = false;
}

- (IBAction)dismissKeyboard:(id)sender {
    [ipTextField resignFirstResponder];
    [portTextField resignFirstResponder];
}


@end
