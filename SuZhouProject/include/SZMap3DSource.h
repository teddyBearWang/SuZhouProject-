//
//  SZMap3DSource.h
//  MapView
//
//  Created by kevinmeng on 14-3-28.
//
//
/*! @name 2.5维地图瓦片源 */
#import "RMAbstractWebMapSource.h"

@interface SZMap3DSource : RMAbstractWebMapSource
/*! 通过密钥初始化瓦片源.
 *
 *   这个方法使用给定的密钥创建一个苏州市2.5维地图瓦片源.
 *
 *   @param apiKey 苏州地图访问密钥，预留接口，现阶段不做任何检测.
 *   @return 返回一个苏州地图瓦片源对象.*/
- (id)initWithApiKey:(NSString *)apiKey;
@property (nonatomic, readonly, assign) dispatch_queue_t dataQueue;
@end
