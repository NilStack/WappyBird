//
//  InterfaceController.m
//  WappyBird@Watch Extension
//
//  Created by Peng on 8/26/15.
//  Copyright © 2015 Peng. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface InterfaceController() <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *operationButton;

@property (assign, nonatomic) BOOL playing;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.operationButton setTitle:@"Tap Me!"];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    
}
- (IBAction)operate {
    WCSession *session = [WCSession defaultSession];
    if ([session isReachable]) {
        
        NSDictionary *message = @{@"Operation":@"bounce"};
        
        
        [session sendMessage:message replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            
            NSString *result = [replyMessage objectForKey:@"Reply"];
            
            NSLog(@"result is : %@", result);
            
        } errorHandler:^(NSError * _Nonnull error) {
            
            if (error) {
               NSLog(@"when send message : %@, error is : %@", message, error);
            }
            
        }];
        
        
    } else {
        
        NSLog(@"not reachable to iPhone");
        
    }
    
}

@end



