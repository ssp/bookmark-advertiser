//
//  Service_Advertiser_AppDelegate.m
//  Service Advertiser
//
//  Created by Sven on 02.12.08.
//  Copyright 2008-2009 Sven-S. Porst.
//

#import "Service_Advertiser_AppDelegate.h"
#import "MyNetService.h"
#import "NSString+Truncation.h"


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


- (BOOL) addServiceWithURLString:(NSString *) URL andName:(NSString *) name {
  BOOL success = NO;
  
  /* DNS-SD Service names may only be 63 bytes of UTF-8 in length. Shorten the name as needed */
  NSString * shorterName = [name truncateWithEllipsisToUTF8Length:63];
  
	NSNetService * netService = [[NSNetService alloc] initWithDomain:@"" type:@"_urlbookmark._tcp." name:shorterName port:77777];
  
  MyNetService * myNS = [[MyNetService alloc] init];
  myNS.URLString = URL;
  myNS.name = name;
  [netServicesController addObject:myNS];

  if ([URL UTF8DataLength] + 4 > 255) {
    /* URL is too long to fit into a TXT Record field */
    myNS.canActivate = NO;
  }
  else {
    /* DNS-SD key value pair in TXT-Records are a maximum of 255 UTF-8 bytes in length. Truncate as needed */
    NSString * shorterName = [name truncateWithEllipsisToUTF8Length: 255 - 5];
    NSDictionary * TXTRecordDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    URL, @"URL", shorterName, @"name", nil];
    success = [netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:TXTRecordDict]];
    if (success) {
      [netService setDelegate:self];
      
      myNS.netService = netService;
      myNS.canActivate = YES;
      myNS.publishedState = NSMixedState;
    }
  }
  return success;
}


- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
  NSLog(@"Failed to publish %@, error: %@", [sender description], [errorDict description]);

  for (MyNetService * m in self.netServices) {
    if ([m.netService isEqual:sender]) {
      m.publishedState= NSOffState;
    }
  }
}


- (void)netServiceDidPublish: (NSNetService *)sender {
  // NSLog(@"Successfully published %@", [sender description]);

  for (MyNetService * m in self.netServices) {
    if ([m.netService isEqual:sender]) {
      m.publishedState = NSOnState;
    }
  }
}


/*
- (NSString *) infoString {
	return [NSString stringWithFormat:NSLocalizedString(@"%i Safari bookmarks advertised via Bonjour", @"# Safari bookmarks advertised via Bonjour"), [[netServicesController content] count]];
}
*/


- (IBAction) openWebPage:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://earthlingsoft.net/code/index.html#bookmarkadvertiser"]];
}


- (IBAction) openGoogleCode:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://code.google.com/p/service-advertiser/"]];
}


- (IBAction) sendEMail:(id)sender {
	NSString * theURL = [NSString stringWithFormat:@"mailto:ssp-web%%40earthlingsoft.net?subject=Bookmark%%20Advertiser%%20%@", [self myVersionString]];
	NSURL * myURL = [NSURL URLWithString:theURL];
	[[NSWorkspace sharedWorkspace] openURL:myURL];
}


- (NSString*) myVersionString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}


@end
