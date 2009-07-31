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
    
	NSMutableArray * netServices;
	IBOutlet NSArrayController * netServicesController;
}

- (void) setupWithCurrentSafariPages;
- (void) runServicesWithURLsFromEventDescriptor: (NSAppleEventDescriptor *) AED;
- (BOOL) addServiceWithURLString:(NSString *) URL andName:(NSString *) name;
// - (NSString *) infoString;

- (IBAction) reload: (id) sender;

@property (retain) NSMutableArray * netServices;


@end


