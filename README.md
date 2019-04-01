# SIPopView

简单弹出框

## 安装
### 1. 手动安装
下载项目,导入`PopView`目录导入项目中.

### 2. Pod安装

	pod 'SIPopView','~>1.0'
	

## 用法

1. 导入头文件

	```objective-c
	#import "SIPopView.h"
	```
	
2. 构造

	```objective-c
	- (instancetype)initWithCustomView:(UIView *)customView
                          popStyle:(SIPopAnimationStyle)popStyle
                      dismissStyle:(SIDismissAnimationStyle)dismissStyle;
	```
	
3. 显示

	```objective-c
	- (void)pop;
	```
	
4. 隐藏

	```objective-c
	- (void)dismiss;
	```
	
## SIPopView
SIPopView is available under the MIT license. See the LICENSE file for more info.