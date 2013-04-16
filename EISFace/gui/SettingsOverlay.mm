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

- (void)updateValues
{
    self.ipTextField.text = [NSString stringWithUTF8String:myApp->host.c_str()];
    self.portTextField.text = [NSString stringWithFormat:@"%d", myApp->port];
    self.meshToggle.on = myApp->bDrawMesh;
    self.consoleToggle.on = myApp->bDrawConsole;
    self.attemptsTextField.text = [NSString stringWithFormat:@"%d", myApp->tracker.getAttempts()];
    self.iterationsTextField.text = [NSString stringWithFormat:@"%d", myApp->tracker.getIterations()];
    self.scaleTextField.text = [NSString stringWithFormat:@"%f", myApp->tracker.getRescale()];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myApp = (testApp*)ofGetAppPtr();
    [self updateValues];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSettings:(id)sender {
    [self updateValues];
    
    self.overlay.hidden = NO;
    self.settingsButton.hidden = YES;
    myApp->bPaused = true;
}

- (IBAction)closeSettings:(id)sender {
    myApp->tracker.reset();
    
    self.overlay.hidden = YES;
    self.settingsButton.hidden = NO;
    myApp->bPaused = false;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.ipTextField resignFirstResponder];
    [self.portTextField resignFirstResponder];
    [self.attemptsTextField resignFirstResponder];
    [self.iterationsTextField resignFirstResponder];
    [self.scaleTextField resignFirstResponder];
    
    myApp->host = ofToString([self.ipTextField.text UTF8String]);
    myApp->port = self.portTextField.text.intValue;
    myApp->tracker.setAttempts(self.attemptsTextField.text.integerValue);
    myApp->tracker.setIterations(self.iterationsTextField.text.integerValue);
    myApp->tracker.setRescale(self.scaleTextField.text.doubleValue);

    myApp->osc.setup(myApp->host, myApp->port);
}

- (IBAction)switchToggled:(id)sender {
    if (sender == self.meshToggle) {
        myApp->bDrawMesh = self.meshToggle.isOn;
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
    } else if (textField == self.attemptsTextField) {
        myApp->tracker.setAttempts(self.attemptsTextField.text.integerValue);
    } else if (textField == self.iterationsTextField) {
        myApp->tracker.setIterations(self.iterationsTextField.text.integerValue);
    } else if (textField == self.scaleTextField) {
        myApp->tracker.setRescale(self.scaleTextField.text.doubleValue);
    }
    myApp->osc.setup(myApp->host, myApp->port);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
