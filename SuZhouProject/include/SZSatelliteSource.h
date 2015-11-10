//
//  SZSatelliteSource.h
//  MapView
//
//  Created by kevinmeng on 14-3-15.
//
//
/*! @name 航拍图瓦片源 */
#import "RMAbstractWebMapSource.h"

@interface SZSatelliteSource : RMAbstractWebMapSource

/*! 通过密钥初始化瓦片源.
 *
 *   这个方法使用给定的密钥创建一个苏州市航拍图瓦片源.
 *
 *   @param apiKey 苏州地图访问密钥，预留接口，现阶段不做任何检测.
 *   @return 返回一个苏州地图瓦片源对象.*/
- (id)initWithApiKey:(NSString *)apiKey;
@property (nonatomic, readonly, assign) dispatch_queue_t dataQueue;
@end
