//
//  Service_Advertiser_AppDelegate.m
//  Service Advertiser
//
//  Created by  Sven on 02.12.08.
//  Copyright earthlingsoft 2008 . All rights reserved.
//

#import "Service_Advertiser_AppDelegate.h"
#import "MyNetService.h"

@implementation Service_Advertiser_AppDelegate

@synthesize netServices;



- (id) init {
	self = [super init];
	if (self) {
		netServices = [NSMutableArray arrayWithCapacity:5]; 
	}
	return self;
}


+ (void)initialize {
    [self setKeys:[NSArray arrayWithObjects:@"netServices",nil] triggerChangeNotificationsForDependentKey:@"infoString"];
}


- (void) awakeFromNib {
	[self setupWithCurrentSafariPages];
}


- (IBAction) reload: (id) sender {
	[self setupWithCurrentSafariPages];	
}


- (void) setupWithCurrentSafariPages {
	// stop current NetServices
	for (MyNetService * myNS in netServices) {
		[myNS.netService stop];
	}
	[netServicesController removeObjects:[netServicesController arrangedObjects]];
	
	// get current pages from Safari
	NSURL * scriptURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Safari URLs" ofType:@"scpt"]];
	NSDictionary * myError;
	NSAppleScript * myAS = [[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&myError];
	NSAppleEventDescriptor * myED = [myAS executeAndReturnError:&myError];

	// set up new services
	[self runServicesWithURLsFromEventDescriptor: myED];
}


- (void) runServicesWithURLsFromEventDescriptor: (NSAppleEventDescriptor *) AED{
	// AED should be array with two strings
	NSAppleEventDescriptor * pageInfoAED;
	for (int i = 0; i < [AED numberOfItems]; i++) {
		pageInfoAED = [AED descriptorAtIndex:i+1];
		NSString * URL = [[pageInfoAED descriptorAtIndex:1] stringValue];
		NSString * name = [[pageInfoAED descriptorAtIndex:2] stringValue];
		[self addServiceWithURLString:URL andName:name];
	}
}

- (void) addServiceWithURLString:(NSString *) URL andName:(NSString *) name {
	NSNetService * netService = [[NSNetService alloc] initWithDomain:@"" type:@"_webbookmark._tcp." name:name port:77777];
	NSDictionary * TXTRecordDict = [NSDictionary dictionaryWithObjectsAndKeys:
									URL, @"URL", name, @"name", nil];
	[netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:TXTRecordDict]];
	[netService publish];
	
	MyNetService * myNS = [[MyNetService alloc] init];
	myNS.netService = netService;
	myNS.URLString = URL;
	myNS.name = name;
	
	[netServicesController addObject:myNS];
}



/*
- (NSString *) infoString {
	return [NSString stringWithFormat:NSLocalizedString(@"%i Safari bookmarks advertised via Bonjour", @"# Safari bookmarks advertised via Bonjour"), [[netServicesController content] count]];
}
*/






































/**
    Returns the support folder for the application, used to store the Core Data
    store file.  This code uses a folder named "Service_Advertiser" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportFolder {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Service_Advertiser"];
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The folder for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
        [fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
    }
    
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"Service_Advertiser.xml"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }    

    return persistentStoreCoordinator;
}


/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}


/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender {

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    NSError *error;
    int reply = NSTerminateNow;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext commitEditing]) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
				
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.

                // Typically, this process should be altered to include application-specific 
                // recovery steps.  

                BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
				
                if (errorResult == YES) {
                    reply = NSTerminateCancel;
                } 

                else {
					
                    int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
                    if (alertReturn == NSAlertAlternateReturn) {
                        reply = NSTerminateCancel;	
                    }
                }
            }
        } 
        
        else {
            reply = NSTerminateCancel;
        }
    }
    
    return reply;
}


/**
    Implementation of dealloc, to release the retained variables.
 */
 
- (void) dealloc {
	[netServices release];
    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}


@end
