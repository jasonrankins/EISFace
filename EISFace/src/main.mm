#include "ofMain.h"
#include "testApp.h"

int main(){
	ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow;
    // iOSWindow -> enableAntiAliasing(4);
    iOSWindow -> enableRetinaSupport();
	ofSetupOpenGL(iOSWindow,640,960, OF_FULLSCREEN);				// <-------- setup the GL context

	ofRunApp(new testApp);
}
