//
//  RBServerStore.m
//  raspberry
//
//  Created by Trevir on 5/31/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBGuildStore.h"
#import "DCChannel.h"

@interface RBGuildStore()

@property NSMutableDictionary* guildDictionary;
@property NSMutableDictionary* channelDictionary;

@end

@implementation RBGuildStore

-(RBGuildStore*)storeReadyEvent:(RBGatewayEvent*)event {
	if(![event.t isEqualToString:@"READY"]){
		NSLog(@"event %i isn't a ready event!", event.s);
		return nil;
	}
	
	self.guildDictionary = [NSMutableDictionary new];
    self.channelDictionary = [NSMutableDictionary new];
	
	NSArray* jsonGuilds = [[NSArray alloc] initWithArray:[event.d objectForKey:@"guilds"]];
	
	for(NSDictionary* jsonGuild in jsonGuilds){
		DCGuild* guild = [[DCGuild alloc]initFromDictionary:jsonGuild];
		[self.guildDictionary setObject:guild forKey:guild.snowflake];
        
        [self.channelDictionary addEntriesFromDictionary:guild.channels];
	}
	
	return self;
}

-(void)addGuild:(DCGuild *)guild{
    [self.guildDictionary setObject:guild forKey:guild.snowflake];
}

-(DCGuild*)guildAtIndex:(int)index{
	NSArray *keys = [self.guildDictionary allKeys];
	return [self.guildDictionary objectForKey:keys[index]];
}

-(DCGuild*)guildOfSnowflake:(NSString *)snowflake{
    return [self.guildDictionary objectForKey:snowflake];
}

-(DCChannel*)channelOfSnowflake:(NSString *)snowflake{
    return [self.channelDictionary objectForKey:snowflake];
}

-(int)count{
	return self.guildDictionary.count;
}

@end