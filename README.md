# HHRefreshManager
This is a simple pretty refresh control that is easy to use.这是一个漂亮简易刷新控件，使用简单。

**[简书地址](https://www.jianshu.com/p/4cd1ef3986ac)**

**效果图如下：**

![refreshStar.gif](https://upload-images.jianshu.io/upload_images/1801563-10a3da0712b8e2ce.gif?imageMogr2/auto-orient/strip) ![refreshSemiPoint.gif](https://upload-images.jianshu.io/upload_images/1801563-ee26cb32675a45c2.gif?imageMogr2/auto-orient/strip)

![refreshSemiCircle.gif](https://upload-images.jianshu.io/upload_images/1801563-eacbe0762160888f.gif?imageMogr2/auto-orient/strip) ![refreshCircle.gif](https://upload-images.jianshu.io/upload_images/1801563-60a4a2415d48db48.gif?imageMogr2/auto-orient/strip)

![refreshNormal.gif](https://upload-images.jianshu.io/upload_images/1801563-515f5cb35ca3f126.gif?imageMogr2/auto-orient/strip)


**使用方法**
>1、手动下载代码，导入头文件`HHRefreshManager.h`

```objc
/**
 实例化方法, 内部KVO监听tableView的contentOffset
 
 @param delegate 代理对象
 @param scrollView 需要监听的对象
 @return 当前类的实例
 */
+ (instancetype)refreshWithDelegate:(id<HHRefreshManagerDelegate>)delegate scrollView:(UIScrollView *)scrollView;


```

```objc
//实例化刷新对象
self.refreshManager = [HHRefreshManager refreshWithDelegate:self scrollView:self.refreshTableView type:self.animationType];

//实现协议方法 `HHRefreshManagerDelegate.h`
- (void)beginRefreshWithType:(HHRefreshType)type;

```

>2、cocoapod下载

```objc
target 'MyApp' do
  pod 'HHRefreshManager', '~> 1.1.1'
end
```


