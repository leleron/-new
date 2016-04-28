//
//  versonEntity.h
//  HelloCordova
//
//  Created by leron on 15/8/25.
//
//

#import "QUEntity.h"

@interface versonEntity : QUEntity
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* code;
@property(strong,getter = theVerson)NSMutableDictionary* newVersion;

@end
