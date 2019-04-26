//
//  main.m
//  ALCPlugFix
//
//  Created by Oleksandr Stoyevskyy on 11/3/16.
//  Copyright © 2016 Oleksandr Stoyevskyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AppKit/AppKit.h>


void fixAudio();

@protocol DaemonProtocol
- (void)performWork;
@end

@interface NSString (ShellExecution)
- (NSString*)runAsCommand;
@end

@implementation NSString (ShellExecution)

- (NSString*)runAsCommand {
    NSPipe* pipe = [NSPipe pipe];

    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
    [task setStandardOutput:pipe];

    NSFileHandle* file = [pipe fileHandleForReading];
    [task launch];

    return [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}

@end

# pragma mark ALCPlugFix Object Conforms to Protocol

@interface ALCPlugFix : NSObject <DaemonProtocol>
@end;
@implementation ALCPlugFix
- (id)init
{
    self = [super init];
    if (self) {
        // Do here what you needs to be done to start things
        
        // Change 'NSWorkspaceDidWakeNotification' to 'NSWorkspaceScreensDidWakeNotification'
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(receiveWakeNote:)
                                                                   name: NSWorkspaceDidWakeNotification object: NULL];
        
        [[NSDistributedNotificationCenter defaultCenter] addObserver: self
                                                               selector: @selector(receiveWakeNote:)
                                                                   name: @"com.apple.screenIsUnlocked" object: NULL];

    }
    return self;
}


- (void)dealloc
{
    // Do here what needs to be done to shut things down
    //[super dealloc];
}

- (void)performWork
{
    // This method is called periodically to perform some routine work
    NSLog(@"Performing periodical work");
    fixAudio();

}
- (void) receiveWakeNote: (NSNotification*) note
{
    NSLog(@"receiveSleepNote: %@", [note name]);
    NSLog(@"Wake detected");
    fixAudio();
}


@end

# pragma mark Setup the daemon

// Seconds runloop runs before performing work in second.
#define kRunLoopWaitTime 3600.0

BOOL keepRunning = TRUE;

void sigHandler(int signo)
{
    NSLog(@"sigHandler: Received signal %d", signo);

    switch (signo) {
        case SIGTERM: keepRunning = FALSE; break; // SIGTERM means we must quit
        default: break;
    }
}

void fixAudio(){
    NSLog(@"Fixing...");
    NSString *output1 = [@"hda-verb 0x18 SET_PIN_WIDGET_CONTROL 0x20" runAsCommand];
    NSString *output2 = [@"hda-verb 0x1a SET_PIN_WIDGET_CONTROL 0x20" runAsCommand];
}





int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Headphones daemon running!");
        
        signal(SIGHUP, sigHandler);
        signal(SIGTERM, sigHandler);

        ALCPlugFix *task = [[ALCPlugFix alloc] init];

        AudioDeviceID defaultDevice = 0;
        UInt32 defaultSize = sizeof(AudioDeviceID);

        const AudioObjectPropertyAddress defaultAddr = {
            kAudioHardwarePropertyDefaultOutputDevice,
            kAudioObjectPropertyScopeGlobal,
            kAudioObjectPropertyElementMaster
        };
        
        
        AudioObjectGetPropertyData(kAudioObjectSystemObject, &defaultAddr, 0, NULL, &defaultSize, &defaultDevice);

        AudioObjectPropertyAddress sourceAddr;
        sourceAddr.mSelector = kAudioDevicePropertyDataSource;
        sourceAddr.mScope = kAudioDevicePropertyScopeOutput;
        sourceAddr.mElement = kAudioObjectPropertyElementMaster;

        // The daemon will call 'performWork' func at start
        //NSLog(@"Init fix");
        //fixAudio();

        AudioObjectAddPropertyListenerBlock(defaultDevice, &sourceAddr, dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(UInt32 inNumberAddresses, const AudioObjectPropertyAddress * inAddresses) {
            // Audio device have changed
            NSLog(@"Audio device changed!");
            fixAudio();
        
        });

        while (keepRunning) {
            [task performWork];
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, kRunLoopWaitTime, false);
        }
//        [task release];

        NSLog(@"Daemon exiting");
    }
    return 0;
}
