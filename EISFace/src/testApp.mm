#include "testApp.h"
#include "SettingsOverlay.h"

SettingsOverlay * settingsView;

using namespace ofxCv;
using namespace cv;

#pragma mark - OSC Methods
template <>
void testApp::addMessage(string address, ofVec3f data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addFloatArg(data.x);
	msg.addFloatArg(data.y);
	msg.addFloatArg(data.z);
	bundle.addMessage(msg);
}

template <>
void testApp::addMessage(string address, ofVec2f data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addFloatArg(data.x);
	msg.addFloatArg(data.y);
	bundle.addMessage(msg);
}

template <>
void testApp::addMessage(string address, float data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addFloatArg(data);
	bundle.addMessage(msg);
}

template <>
void testApp::addMessage(string address, int data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addIntArg(data);
	bundle.addMessage(msg);
}

void testApp::sendBundle() {
	osc.sendBundle(bundle);
}

void testApp::clearBundle() {
	bundle.clear();
}

void testApp::addTrackingMessages() {
    if(tracker.getFound()) {
        addMessage("/found", 1);
        
        ofVec2f position = tracker.getPosition();
        addMessage("/pose/position", position);
        scale = tracker.getScale();
        addMessage("/pose/scale", scale);
        ofVec3f orientation = tracker.getOrientation();
        addMessage("/pose/orientation", orientation);
        
        addMessage("/gesture/mouth/width", tracker.getGesture(ofxFaceTracker::MOUTH_WIDTH));
        addMessage("/gesture/mouth/height", tracker.getGesture(ofxFaceTracker::MOUTH_HEIGHT));
        addMessage("/gesture/eyebrow/left", tracker.getGesture(ofxFaceTracker::LEFT_EYEBROW_HEIGHT));
        addMessage("/gesture/eyebrow/right", tracker.getGesture(ofxFaceTracker::RIGHT_EYEBROW_HEIGHT));
        addMessage("/gesture/eye/left", tracker.getGesture(ofxFaceTracker::LEFT_EYE_OPENNESS));
        addMessage("/gesture/eye/right", tracker.getGesture(ofxFaceTracker::RIGHT_EYE_OPENNESS));
        addMessage("/gesture/jaw", tracker.getGesture(ofxFaceTracker::JAW_OPENNESS));
        addMessage("/gesture/nostrils", tracker.getGesture(ofxFaceTracker::NOSTRIL_FLARE));
        
        settingsView.eyebrows.text = [NSString stringWithFormat:@"%f, %f",
                                      tracker.getGesture(ofxFaceTracker::LEFT_EYEBROW_HEIGHT),
                                      tracker.getGesture(ofxFaceTracker::RIGHT_EYEBROW_HEIGHT)];
        settingsView.eyes.text = [NSString stringWithFormat:@"%f, %f",
                                  tracker.getGesture(ofxFaceTracker::LEFT_EYE_OPENNESS),
                                  tracker.getGesture(ofxFaceTracker::RIGHT_EYE_OPENNESS)];
        settingsView.nostrils.text = [NSString stringWithFormat:@"%f",
                                      tracker.getGesture(ofxFaceTracker::NOSTRIL_FLARE)];
        settingsView.mouth.text = [NSString stringWithFormat:@"(%f, %f)",
                                   tracker.getGesture(ofxFaceTracker::MOUTH_WIDTH),
                                   tracker.getGesture(ofxFaceTracker::MOUTH_HEIGHT)];
        settingsView.jaw.text = [NSString stringWithFormat:@"%f",
                                 tracker.getGesture(ofxFaceTracker::JAW_OPENNESS)];
        settingsView.position.text = [NSString stringWithFormat:@"(%f, %f)",
                                      position.x, position.y];
        settingsView.orientation.text = [NSString stringWithFormat:@"(%f, %f, %f)",
                                         orientation.x, orientation.y, orientation.z];
        settingsView.scale.text = [NSString stringWithFormat:@"%f", scale];
    } else {
        addMessage("/found", 0);
        settingsView.eyebrows.text = @"UNKNOWN";
        settingsView.eyes.text = @"UNKNOWN";
        settingsView.nostrils.text = @"UNKNOWN";
        settingsView.mouth.text = @"UNKNOWN";
        settingsView.jaw.text = @"UNKNOWN";
        settingsView.position.text = @"UNKNOWN";
        settingsView.orientation.text = @"UNKNOWN";
        settingsView.scale.text = @"UNKNOWN";
    }
}

#pragma mark - Application Lifecycle
void testApp::setup() {
    loadSettings();
    
    if (IS_IPAD()) {
        settingsView = [[SettingsOverlay alloc] initWithNibName:@"SettingsOverlayIpad" bundle:nil];
    } else {
        settingsView = [[SettingsOverlay alloc] initWithNibName:@"SettingsOverlay" bundle:nil];
    }
    
    [ofxiPhoneGetGLView() insertSubview:settingsView.view atIndex:0];
    ofBackground(60, 60, 60);
	ofSetVerticalSync(false);
}

void testApp::update() {
    settingsView.fpsLabel.text = [NSString stringWithFormat:@"%d", (int)ofGetFrameRate()];
    if (bPaused) {
        settingsView.trackingStatus.text = @"PAUSED";
	} else if(tracker.getFound()) {
        settingsView.trackingStatus.text = @"TRACKING";
    } else {
        settingsView.trackingStatus.text = @"SEARCHING";
    }
    
	if(bPaused)
		return;
    
	videoSource->update();
	if(videoSource->isFrameNew()) {
        ofPixels proxy;
        proxy.setFromExternalPixels(cam.getPixels(), cam.getWidth(), cam.getHeight(), 3);
		tracker.update(toCv(proxy));
		clearBundle();
        addTrackingMessages();
		sendBundle();
        
		rotationMatrix = tracker.getRotationMatrix();
	}
}

#pragma mark - Debug Drawing
void testApp::drawStringWithShadow(string string, int x, int y) {
    ofSetColor(0);
    ofDrawBitmapString(string, x+1, y+1);
    ofSetColor(255);
    ofDrawBitmapString(string, x, y);
}

void testApp::drawStatus(int x, int y) {
    string status = "";
    
    if(!bPaused && tracker.getFound()) {
		if(bDrawMesh) {
			ofSetLineWidth(1);
			tracker.draw();
			tracker.getImageMesh().drawWireframe();
            
			ofPushView();
			ofSetupScreenOrtho(sourceWidth, sourceHeight, OF_ORIENTATION_UNKNOWN, true, -1000, 1000);
			ofVec2f pos = tracker.getPosition();
			ofTranslate(pos.x, pos.y);
			applyMatrix(rotationMatrix);
			ofScale(10,10,10);
			ofDrawAxis(scale);
			ofPopView();
        }
	}
    if (bDrawConsole) {
        drawStringWithShadow(status, x, y);
    }
}

void testApp::drawSelectedCamera(int x, int y) {
    string camera;
    switch ((int)selectedCamera) {
        case cameraIdRear:
            camera = "rear camera";
            break;
        case cameraIdFront:
            camera = "front camera";
            break;
        default:
            camera = "unknown camera";
            break;
    }
    drawStringWithShadow(camera, x, y);
}

void testApp::drawOscDestination(int x, int y) {
    string destination = host + ":" + ofToString((int) port);
    drawStringWithShadow(destination, x, y);
}

void testApp::draw() {
	ofSetColor(255);
	videoSource->draw(0, 0, videoSource->getWidth(), videoSource->getHeight());
    drawStatus(10, 40);
}

void testApp::exit(){
}


void testApp::keyPressed(int key) {
}

#pragma mark - Settings
void testApp::loadSettings() {
	ofxXmlSettings xml;
	xml.loadFile("settings.xml");
    
	xml.pushTag("camera");
	if(xml.getNumTags("device") > 0) {
		cam.setDeviceID(xml.getValue("device", 0));
        selectedCamera = (cameraId)xml.getValue("device", 0);
	} else {
        cam.setDeviceID(1);
        selectedCamera = (cameraId)1;
    }
	if(xml.getNumTags("framerate") > 0) {
		cam.setDesiredFrameRate(xml.getValue("framerate", 30));
	}
	camWidth = xml.getValue("width", 640);
	camHeight = xml.getValue("height", 480);
	cam.initGrabber(camWidth, camHeight);
	xml.popTag();

	bPaused = false;
	movieWidth = movie.getWidth();
	movieHeight = movie.getHeight();
    
    ofSetWindowShape(camWidth, camHeight);
    setVideoSource(true);
    
	xml.pushTag("face");
	if(xml.getNumTags("rescale")) {
		tracker.setRescale(xml.getValue("rescale", 0.5));
	}
	if(xml.getNumTags("iterations")) {
		tracker.setIterations(xml.getValue("iterations", 5));
	}
	if(xml.getNumTags("clamp")) {
		tracker.setClamp(xml.getValue("clamp", 3.));
	}
	if(xml.getNumTags("tolerance")) {
		tracker.setTolerance(xml.getValue("tolerance", .01));
	}
	if(xml.getNumTags("attempts")) {
		tracker.setAttempts(xml.getValue("attempts", 1));
	}
	bDrawMesh = true;
	if(xml.getNumTags("drawMesh")) {
		bDrawMesh = (bool) xml.getValue("drawMesh", 1);
	}
	tracker.setup();
	xml.popTag();
    
	xml.pushTag("osc");
	host = xml.getValue("host", "255.255.255.255");
	port = xml.getValue("port", 8338);
	osc.setup(host, port);
	xml.popTag();
}

void testApp::saveSettings() {
	ofxXmlSettings xml;
    
	xml.pushTag("camera");
    xml.setValue("device", selectedCamera);
    xml.setValue("width", 640);
    xml.setValue("height", 480);
	xml.popTag();
    
	xml.pushTag("face");
    xml.setValue("rescale", tracker.getRescale());
	xml.setValue("iterations", tracker.getIterations());
    xml.setValue("attempts", tracker.getAttempts());
    xml.setValue("drawMesh", bDrawMesh);
	xml.popTag();
    
	xml.pushTag("osc");
    xml.setValue("host", host);
    xml.setValue("port", port);
	xml.popTag();
	
    xml.saveFile("settings.xml");
}

void testApp::setVideoSource(bool useCamera) {
	if(useCamera) {
		videoSource = &cam;
		sourceWidth = camWidth;
		sourceHeight = camHeight;
	}
	else {
		videoSource = &movie;
		sourceWidth = movieWidth;
		sourceHeight = movieHeight;
	}
}

#pragma mark - Touch Events
void testApp::touchDown(ofTouchEventArgs & touch){
    tracker.reset();
}

void testApp::touchMoved(ofTouchEventArgs & touch){
    
}

void testApp::touchUp(ofTouchEventArgs & touch){

}

void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    bPaused = !bPaused;
}

void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

#pragma mark - Application Delegate
void testApp::lostFocus(){
    saveSettings();
}

void testApp::gotFocus(){
    
}

void testApp::gotMemoryWarning(){
    
}

void testApp::deviceOrientationChanged(int newOrientation){
//    if (IS_IPAD()) {
//        ofSetOrientation(ofOrientation, false);
//        SettingsOverlay *view;
//        if (UIDeviceOrientationIsLandscape(newOrientation)) {
//            view = [[SettingsOverlay alloc] initWithNibName:@"SettingsOverlayIpadLandscape" bundle:nil];
//        } else {
//            view = [[SettingsOverlay alloc] initWithNibName:@"SettingsOverlayIpad" bundle:nil];
//        }
//        [settingsView.view removeFromSuperview];
//        settingsView = view;
//        [ofxiPhoneGetGLView() insertSubview:settingsView.view atIndex:0];
//    }
}
