//
//  SZMapSource.h
//  MapView
//
//  Created by Liyi Meng on 16/11/13.
//  这个类提供苏州城市规划局地图接口，同时它对object-c代码进行详尽解释，以帮助object-c初学者快速入门。
//  
//

#import "RMAbstractWebMapSource.h"

// 下面一行代码表示SZMapSource继承了RMAbstractWebMapSource，相当Java中的class SZMapSource extends RMAbstractWebMapSource.
@interface SZMapSource : RMAbstractWebMapSource

/** @name 创建瓦片源 */

/** 通过密钥初始化瓦片源.
 *
 *   这个方法使用给定的密钥创建一个苏州地图瓦片源.
 *
 *   @param apiKey 苏州地图访问密钥，必须提前申请`.
 *   @return 返回一个苏州地图瓦片源对象.*/

// Object-c 解释
// - : 表示这个方法是实例方法，不是类方法。实例方法的意思就是这个方法必须有了实例才能调用，类方法则可以通过类名直接调用，类似Java中的static方法。
// (id) : 表示这个方法返回一个指针，这个指针指向这个类一个实例。
// initWithApiKey : 这个是方法名称
// (NSString *)apiKey 是方法的参数，apiKey 是参数名；(NSString *)是参数类型，即此参数是一个字符串引用
//
- (id)initWithApiKey:(NSString *)apiKey;

// 靠，我搞不明白为什么需要这个! 但有了它，地图图像才显示出来！估计是“线程”相关的。
@property (nonatomic, readonly, assign) dispatch_queue_t dataQueue;

@end
