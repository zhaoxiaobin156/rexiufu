//
//  ViewController.m
//  03-地图显示
//
//  Created by vera on 16/5/7.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "ViewController.h"

//地图显示类
#import <MapKit/MapKit.h>
//MapKit.framework


#import "MyAnnation.h"

@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
    
    
    /*
     大学城地铁站：22.5818930000,113.9651270000
     */
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //是否显示用户当前的位置
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    self.mapView = mapView;

    
    //经纬度
    CLLocationCoordinate2D coordinate2D = {22.5818930000, 113.9651270000};
    //比例尺,比例值越小越精确
    MKCoordinateSpan span = {0.05, 0.05};
    //范围
    MKCoordinateRegion region = {coordinate2D, span};
  
    //设置范围
    [mapView setRegion:region animated:YES];
   


    //添加手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    [mapView addGestureRecognizer:longPress];
    
    
  
}

/**
 *  长按事件处理
 *
 *  @param longGesture <#longGesture description#>
 */
- (void)longPressHandle:(UILongPressGestureRecognizer *)longGesture
{
    /**
     *  长按开始
     */
    if (longGesture.state == UIGestureRecognizerStateBegan)
    {
        //0.先移除原来的大头针
        [self.mapView removeAnnotations:self.mapView.annotations];
        //0.1 在移除覆盖物
        [self.mapView removeOverlays:self.mapView.overlays];
        
        
        //1.获取当前点击的经纬度
        CGPoint point = [longGesture locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        //2.把经纬度转化为地理位置
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        /*
         地理编码类,需要网络。
         */
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //这个方法是同步的
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (!error && placemarks.count > 0)
            {
                //保存地理位置的详细信息
                CLPlacemark *placemark = [placemarks firstObject];
                
                //1.创建标注对象
                MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
                pin.coordinate = coordinate;
                pin.title = placemark.name;
                pin.subtitle = placemark.thoroughfare;
                [self.mapView addAnnotation:pin];
                
                /*
                 MKCircle:圆形覆盖物
                 MKPolygon:多边形覆盖物
                 MKPolyline:直线覆盖物
                 */
                //2.添加覆盖物
                MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:500];
                //添加覆盖物
                [self.mapView addOverlay:circle];
            
                
                
                NSLog(@"名字：%@",placemark.name);
                NSLog(@"街道：%@",placemark.thoroughfare);
                NSLog(@"号：%@",placemark.subThoroughfare);
                NSLog(@"市：%@",placemark.locality);
                NSLog(@"区：%@",placemark.subLocality);
                NSLog(@"省：%@",placemark.administrativeArea);
                NSLog(@"县：%@",placemark.subAdministrativeArea);
                
            
                //            self.navigationItem.leftBarButtonItem.title = city;
                
            }
        }];
        
    }
}

#pragma mark - MKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //用户当前的标注不定制
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinIdentifier"];
    
    if (!pin)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinIdentifier"];
        //大头针从天而降
        pin.animatesDrop = YES;
        //显示气泡
        pin.canShowCallout = YES;
    }
    
    return pin;
}

/**
 *  返回渲染后的覆盖物
 *
 *  @param mapView <#mapView description#>
 *  @param overlay <#overlay description#>
 *
 *  @return <#return value description#>
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"%@",overlay);
    
    //圆形的渲染对象
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    //填充颜色
    renderer.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    //线条的颜色
    renderer.strokeColor = [UIColor redColor];
    //线条宽度
    renderer.lineWidth = 1;
    
    return renderer;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
