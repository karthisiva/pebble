//
//  AppDelegate.h
//  pebble-watch version
//
//  Created by Sathish on 23/06/15.
//  Copyright (c) 2015 Optisol Business Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PebbleKit/PebbleKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (PBWatch *)getConnectedWatch;


@end

