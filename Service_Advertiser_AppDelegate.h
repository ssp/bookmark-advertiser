//
//  Service_Advertiser_AppDelegate.h
//  Service Advertiser
//
//  Created by  Sven on 02.12.08.
//  Copyright earthlingsoft 2008 . All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Service_Advertiser_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;

	NSMutableArray * netServices;
	IBOutlet NSArrayController * netServicesController;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

- (void) setupWithCurrentSafariPages;
- (void) runServicesWithURLsFromEventDescriptor: (NSAppleEventDescriptor *) AED;
- (void) addServiceWithURLString:(NSString *) URL andName:(NSString *) name;
// - (NSString *) infoString;

- (IBAction) reload: (id) sender;

@property (retain) NSMutableArray * netServices;


@end


