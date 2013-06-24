#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxCv.h"
#include "ofxFaceTracker.h"

#include "ofxOsc.h"
#include "ofxXmlSettings.h"

typedef enum _cameraId {
    cameraIdFront = 0,
    cameraIdRear = 1
} cameraId;

class testApp : public ofxiPhoneApp{
private:
    void addTrackingMessages();
    void drawStringWithShadow(string string, int x, int y);
    void drawStatus(int x, int y);
    void drawFPS(int x, int y);
    void drawSelectedCamera(int x, int y);
    void drawOscDestination(int x, int y);
    
public:
    
#pragma mark - Function Declarations
    void loadSettings();
    void saveSettings();
    
    void clearBundle();
    template <class T>
    void addMessage(string address, T data);
    void sendBundle();
    
    void setup();
    void update();
    void draw();
    void keyPressed(int key);
    
    void setVideoSource(bool useCamera);
    
    void exit();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    //void gotMessage(ofMessage msg);
	
    void drawGrid(float x, float y);
    
	//void setUIOverlay();
    void setUISettings();
    
#pragma mark - Member Variables
    bool bUseCamera, bPaused;
    
    int camWidth, camHeight;
    int movieWidth, movieHeight;
    int sourceWidth, sourceHeight;
    
    string host;
    int port;
    ofxOscSender osc;
    ofxOscBundle bundle;
    
    ofVideoGrabber cam;
    ofVideoPlayer movie;
    ofBaseVideoDraws *videoSource;
    
    ofxFaceTracker tracker;
    float scale;
    ofMatrix4x4 rotationMatrix;
    
    bool bDrawMesh;
    
    cameraId selectedCamera;
    
	bool hideGUI;
	
	float red, green, blue;
	bool bdrawGrid;
	bool bdrawPadding;
    bool bDrawConsole;
    
    float *buffer;
    ofImage *img;
};


