//
//  DisplayMap.m
//  SocialTagApp
//
//  Created by Menelaos on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayMap.h"

@implementation DisplayMap
@synthesize coordinate,title,subtitle;

-(void)dealloc{
  
    [subtitle release];
    [title release];
    [super dealloc];
}
@end
