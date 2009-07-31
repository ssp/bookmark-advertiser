//
//  MyNetService.m
//  Service Advertiser
//
//  Created by  Sven on 14.12.08.
//  Copyright 2008 earthlingsoft. All rights reserved.
//

#import "MyNetService.h"


@implementation MyNetService
@synthesize name, URLString, netService, canActivate;

- (NSInteger) publishedState {
  return publishedState;
}


- (void) setPublishedState: (NSInteger) newPublished {
  if (newPublished != publishedState) {
    publishedState = newPublished;
    if (newPublished == NSMixedState) {
      [self.netService publish];
    }
    else if (newPublished == NSOnState) {
      
    }
    else if (newPublished == NSOffState) {
      [self.netService stop];
    }
  }
}


@end
