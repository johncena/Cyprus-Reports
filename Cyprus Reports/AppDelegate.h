//
//  AppDelegate.h
//  Cyprus Reports
//
//  Created by Menelaos on 12/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeScreen.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookScreen.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}
extern NSString *const FBSessionStateChangedNotification;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(assign) BOOL isLogin;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
