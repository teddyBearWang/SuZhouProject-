//
//  SZComunnitySource.h
//  MapView
//
//  Created by kevinmeng on 14-3-30.
//
//
/*! @name 社区图瓦片源 */
#import "RMAbstractWebMapSource.h"

@interface SZCommunitySource : RMAbstractWebMapSource
/*! 通过密钥初始化瓦片源.
 *
 *   这个方法使用给定的密钥创建一个苏州市社区图瓦片源.
 *
 *   @param apiKey 苏州地图访问密钥，预留接口，现阶段不做任何检测.
 *   @return 返回一个苏州地图瓦片源对象.*/
- (id)initWithApiKey:(NSString *)apiKey;
@property (nonatomic, readonly, assign) dispatch_queue_t dataQueue;
@end
