#include "testApp.h"

using namespace ofxCv;

//--------------------------------------------------------------
void testApp::setup(){	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(127,127,127);
    
    ofSetFrameRate(30);
    ofSetVerticalSync(false);
	ofSetDrawBitmapMode(OF_BITMAPMODE_MODEL_BILLBOARD);
	
    cam.setDeviceID(1);
    cam.initGrabber(cam.getWidth(), cam.getHeight());
    
	tracker.setup();
    tracker.setRescale(0.25);
    framePadding = 0;
}

//--------------------------------------------------------------
void testApp::update(){
    cam.update();
    if(cam.isFrameNew()){// && cam.getPixelsRef().size() > 0) {
        image.setFromPixels(cam.getPixels(), cam.getWidth(), cam.getHeight(), OF_IMAGE_COLOR);
        tracker.update(toCv(image));
        //Mat pixels = toCv(cam.getPixelsRef());
		//tracker.update(toCv(cam.getPixelsRef()));
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	ofSetColor(255);
    cam.draw(0, 0, 768, 1024);
	ofDrawBitmapString(ofToString((int) ofGetFrameRate()), 10, 20);
	
	ofPolyline leftEye = tracker.getImageFeature(ofxFaceTracker::LEFT_EYE);
	ofPolyline rightEye = tracker.getImageFeature(ofxFaceTracker::RIGHT_EYE);
	ofPolyline faceOutline = tracker.getImageFeature(ofxFaceTracker::FACE_OUTLINE);
	
	ofSetLineWidth(2);
	ofSetColor(ofColor::red);
	leftEye.draw();
	ofSetColor(ofColor::green);
	rightEye.draw();
	ofSetColor(ofColor::blue);
	faceOutline.draw();
	
	ofSetLineWidth(1);
	ofSetColor(255);
	tracker.draw();
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    tracker.reset();
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

