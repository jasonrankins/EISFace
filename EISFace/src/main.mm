#include "ofMain.h"
#include "testApp.h"

int main(){
	ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow;
    //iOSWindow -> enableRetinaSupport();
    if (IS_IPAD()) {
        ofSetupOpenGL(iOSWindow, 768, 1024, OF_FULLSCREEN);
    } else {
        ofSetupOpenGL(iOSWindow, 320, 480, OF_FULLSCREEN);
    }

	ofRunApp(new testApp);
}
