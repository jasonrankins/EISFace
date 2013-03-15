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

- (void)viewDidLoad
{
    [super viewDidLoad];
    myApp = (testApp*)ofGetAppPtr();
    self.ipTextField.text = [NSString stringWithUTF8String:myApp->host.c_str()];
    self.portTextField.text = [NSString stringWithFormat:@"%d", myApp->port];
    self.meshToggle.on = myApp->bDrawMesh;
    self.consoleToggle.on = myApp->bDrawConsole;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSettings:(id)sender {
    self.overlay.hidden = NO;
    self.settingsButton.hidden = YES;
    myApp->bPaused = true;
}

- (IBAction)closeSettings:(id)sender {
    self.overlay.hidden = YES;
    self.settingsButton.hidden = NO;
    myApp->bPaused = false;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.ipTextField resignFirstResponder];
    [self.portTextField resignFirstResponder];
}

- (IBAction)switchToggled:(id)sender {
    if (sender == self.meshToggle) {
        myApp->bdrawGrid = self.meshToggle.isOn;
    } else if (sender == self.consoleToggle) {
        myApp->bDrawConsole = self.consoleToggle.isOn;
    }
}

- (IBAction)reset:(id)sender {
    myApp->tracker.reset();
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.ipTextField) {
        myApp->host = ofToString([self.ipTextField.text UTF8String]);
    } else if (textField == self.portTextField) {
        myApp->port = self.portTextField.text.intValue;
    }
    myApp->osc.setup(myApp->host, myApp->port);
}

@end
