//
//  MyNetService.h
//  Service Advertiser
//
//  Created by  Sven on 14.12.08.
//  Copyright 2008 earthlingsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyNetService : NSObject {
	NSNetService * netService;
	NSString * name;
	NSString * URLString;
}

@property (retain) NSNetService * netService;
@property (retain) NSString * name;
@property (retain) NSString * URLString;

@end
