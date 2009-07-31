//
//  Service_Advertiser_AppDelegate.h
//  Service Advertiser
//
//  Created by Sven on 02.12.08.
//  Copyright 2008-2009 Sven-S. Porst.
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

- (IBAction) openGoogleCode:(id)sender;
- (IBAction) sendEMail:(id)sender;
- (NSString*) myVersionString;

@property (retain) NSMutableArray * netServices;


@end


