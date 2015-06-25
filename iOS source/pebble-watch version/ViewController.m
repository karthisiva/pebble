//
//  ViewController.m
//  pebble-watch version
//
//  Created by Sathish on 23/06/15.
//  Copyright (c) 2015 Optisol Business Solution. All rights reserved.
//

#import "ViewController.h"
#import "PebbleKit/PebbleKit.h"
#import "AppDelegate.h"

@interface ViewController ()<PBPebbleCentralDelegate>
@property PBWatch *watch;
@property (strong, nonatomic) IBOutlet UITextField *txtToSend;
- (IBAction)send:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.watch = [delegate getConnectedWatch];
    
    // Check the watch object is available
    if(self.watch) {
        NSLog(@"i think got its work");
        [self.watch getVersionInfo:^(PBWatch *watch, PBVersionInfo *versionInfo ) {
            NSLog(@"Pebble name: %@", [watch name]);
            NSLog(@"Pebble serial number: %@", [watch serialNumber]);
            NSLog(@"Pebble firmware os version: %li", (long)versionInfo.runningFirmwareMetadata.version.os);
            NSLog(@"Pebble firmware major version: %li", (long)versionInfo.runningFirmwareMetadata.version.major);
            NSLog(@"Pebble firmware minor version: %li", (long)versionInfo.runningFirmwareMetadata.version.minor);
            NSLog(@"Pebble firmware suffix version: %@", versionInfo.runningFirmwareMetadata.version.suffix);
        } onTimeout:^(PBWatch *watch) {
            NSLog(@"Timed out trying to get version info from Pebble.");
        }];
        
        
        [self.watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
            if(isAppMessagesSupported) {
                // Tell the user using the Label
                NSLog(@"can send data to watch");
            } else {
                NSLog(@"cannot send data to watch");
            }
        }];

    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    
    [self.watch appMessagesLaunch:^(PBWatch *watch, NSError *error) {
        if (!error) {
            NSLog(@"Successfully launched app.");
        }
        else {
            NSLog(@"Error launching app - Error: %@", error);
        }
    }
     ];
    // Register to receive events
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    // Set UUID
        uuid_t myAppUUIDbytes;
        NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"3c74cf8f-74e5-4975-8ad5-e4b25beea86f"];
          [myAppUUID getUUIDBytes:myAppUUIDbytes];
        [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];

    NSDictionary *message = @{@(0):@"optisol",
                              };
    NSLog(@"%@",message);
    [self.watch appMessagesPushUpdate:message onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        NSLog(@"getting called");
        if (!error) {
            NSLog(@"Message sent!!!!!!!!");
        }
        else
        {
            NSLog(@"Message not sent!!!!!!!!\n\n%@",error.localizedDescription);

        }
        
        
    }];
    
    [self.watch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
        // Process incoming messages
        NSLog(@"%@",update);
        NSLog(@"received called");
        
        return YES;
    }];
}
@end
