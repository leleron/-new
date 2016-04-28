//
//  airSoundSetMock.m
//  Empty
//
//  Created by leron on 15/12/1.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "airSoundSetMock.h"
#import "identifyEntity.h"
@implementation airSoundSetParam

@end

@implementation airSoundSetMock

-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
