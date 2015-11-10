//
//  SZPoiSource.h
//  MapView
//
//  Created by fanzhenlin on 14-4-19.
//
//

/*! @name 兴趣点图瓦片源 */
#import "RMAbstractWebMapSource.h"

@interface SZPoiSource : RMAbstractWebMapSource
/*! 通过密钥初始化瓦片源.
 *
 *   这个方法使用给定的密钥创建一个苏州市兴趣点瓦片源，用于叠加在影像图上.
 *
 *   @param apiKey 苏州地图访问密钥，预留接口，现阶段不做任何检测.
 *   @return 返回一个苏州地图瓦片源对象.*/
- (id)initWithApiKey:(NSString *)apiKey;
@property (nonatomic, readonly, assign) dispatch_queue_t dataQueue;
@end
