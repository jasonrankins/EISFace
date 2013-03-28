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
    } else {
        addMessage("/found", 0);
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
    [ofxiPhoneGetGLView() addSubview:settingsView.view];
    settingsView.overlay.hidden = YES;
    
	ofSetVerticalSync(true);
#ifdef TARGET_OSX
	ofSetDataPathRoot("../Resources/data/");
#endif
    tracker.setRescale(0.25);
}

void testApp::update() {
	if(bPaused)
		return;
    
	videoSource->update();
	if(videoSource->isFrameNew()) {
        //image.setFromPixels(videoSource->getPixelsRef());
        image.setFromPixels(cam.getPixels(), cam.getWidth(), cam.getHeight(), OF_IMAGE_COLOR);
		tracker.update(toCv(image));//toCv(*videoSource));
        
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
    
    if(bPaused) {
        status = "paused";
	} else if(tracker.getFound()) {
		status = "tracking face";
        
		if(bDrawMesh) {
			ofSetLineWidth(1);
			//tracker.draw();
			tracker.getImageMesh().drawWireframe();
            
			ofPushView();
			ofSetupScreenOrtho(sourceWidth, sourceHeight, OF_ORIENTATION_UNKNOWN, true, -1000, 1000);
			ofVec2f pos = tracker.getPosition();
			ofTranslate(pos.x, pos.y);
			applyMatrix(rotationMatrix);
			ofScale(10,10,10);
			ofDrawAxis(scale);
			ofPopView();
		} else {
            status += " // mesh hidden";
        }
	} else {
		status = "searching for face";
	}
    if (bDrawConsole) {
        drawStringWithShadow(status, x, y);
    }
}

void testApp::drawFPS(int x, int y) {
    string fps = ofToString((int) ofGetFrameRate());
    drawStringWithShadow(fps, x, y);
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
	videoSource->draw(0, 0, ofGetWidth(), ofGetHeight());
    
    if (settingsView.overlay.hidden) {
        drawStatus(10, 40);
        if(bDrawConsole) {
            drawOscDestination(10, 20);
            drawSelectedCamera(10, 60);
            drawFPS(10, 80);
        }
     
        if(!bUseCamera) {
            ofSetColor(255, 0, 0);
            ofDrawBitmapString("speed "+ofToString(movie.getSpeed()), ofGetWidth()-100, 20);
        }
    }
}

void testApp::exit(){
}


void testApp::keyPressed(int key) {
	switch(key) {
		case 'r':
			tracker.reset();
			break;
		case 'm':
			bDrawMesh = !bDrawMesh;
			break;
		case 'p':
			bPaused = !bPaused;
			break;
		case OF_KEY_UP:
			movie.setSpeed(ofClamp(movie.getSpeed()+0.2, -16, 16));
			break;
		case OF_KEY_DOWN:
			movie.setSpeed(ofClamp(movie.getSpeed()-0.2, -16, 16));
			break;
	}
}

#pragma mark - Settings
void testApp::loadSettings() {
	ofxXmlSettings xml;
	xml.loadFile("settings.xml");
    
	bool bUseCamera = true;
    
	xml.pushTag("source");
	if(xml.getNumTags("useCamera") > 0) {
		bUseCamera = xml.getValue("useCamera", 0);
	}
	xml.popTag();
    
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
    
	xml.pushTag("movie");
	if(xml.getNumTags("filename") > 0) {
		string filename = ofToDataPath((string) xml.getValue("filename", ""));
		if(!movie.loadMovie(filename)) {
			ofLog(OF_LOG_ERROR, "Could not load movie \"%s\", reverting to camera input", filename.c_str());
			bUseCamera = true;
		}
		movie.play();
	}
	else {
		ofLog(OF_LOG_ERROR, "Movie filename tag not set in settings, reverting to camera input");
		bUseCamera = true;
	}
	if(xml.getNumTags("volume") > 0) {
		float movieVolume = ofClamp(xml.getValue("volume", 1.0), 0, 1.0);
		movie.setVolume(movieVolume);
	}
	if(xml.getNumTags("speed") > 0) {
		float movieSpeed = ofClamp(xml.getValue("speed", 1.0), -16, 16);
		movie.setSpeed(movieSpeed);
	}
	bPaused = false;
	movieWidth = movie.getWidth();
	movieHeight = movie.getHeight();
	xml.popTag();
    
	if(bUseCamera) {
		ofSetWindowShape(camWidth, camHeight);
		setVideoSource(true);
	}
	else {
		ofSetWindowShape(movieWidth, movieHeight);
		setVideoSource(false);
	}
    
	xml.pushTag("face");
	if(xml.getNumTags("rescale")) {
		tracker.setRescale(xml.getValue("rescale", 1.));
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
	host = xml.getValue("host", "localhost");
	port = xml.getValue("port", 8338);
	osc.setup(host, port);
    
	xml.popTag();
    
	osc.setup(host, port);
}

void testApp::setVideoSource(bool useCamera) {
    
	bUseCamera = useCamera;
    
	if(bUseCamera) {
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
    
}

void testApp::gotFocus(){
    
}

void testApp::gotMemoryWarning(){
    
}

void testApp::deviceOrientationChanged(int newOrientation){
    
}
