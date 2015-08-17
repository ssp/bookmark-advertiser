//
//  Service_Advertiser_AppDelegate.h
//  Service Advertiser
//
//  Created by Sven on 02.12.08.
//  Copyright 2008-2015 Sven-S. Porst.
//

#import <Cocoa/Cocoa.h>


@interface Service_Advertiser_AppDelegate : NSObject<NSNetServiceDelegate> {
	IBOutlet NSWindow *window;
    
	NSMutableArray * netServices;
	IBOutlet NSArrayController * netServicesController;
}

- (void) setupWithCurrentSafariPages;
- (void) runServicesWithURLsFromEventDescriptor: (NSAppleEventDescriptor *) AED;
- (BOOL) addServiceWithURLString:(NSString *) URL andName:(NSString *) name;

- (IBAction) reload: (id) sender;


- (NSImage *) safariBookmarkIcon;

- (IBAction) openWebPage:(id)sender;
- (IBAction) openGithub:(id)sender;
- (IBAction) sendEMail:(id)sender;
- (NSString *) myVersionString;

@property (strong) NSMutableArray * netServices;


@end


