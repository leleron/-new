//
//  versonUpdateMock.h
//  HelloCordova
//
//  Created by leron on 15/8/25.
//
//

#import "QUMock.h"
#import "versonEntity.h"
@interface versonUpdateParam : QUMockParam
@property(strong,nonatomic)NSString* CURRENTVERSION;
@property(strong,nonatomic)NSString* APPTYPE;
@end


@interface versonUpdateMock : QUMock

@end
