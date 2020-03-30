import 'dart:async';

//import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/util/Adapt.dart';

import 'boolean_setting.dart';

/*
*集成高德地圖導航
 */
class GDNavigation extends StatefulWidget {
  final double longitude;
  final double latitude;

  const GDNavigation({Key key, this.longitude, this.latitude}) : super(key: key);
  @override
  _GDNavigationState createState() => _GDNavigationState();
}
// [AMapNaviKit] 要在iOS 11及以上版本使用定位服务, 需要在Info.plist中添加NSLocationAlwaysAndWhenInUseUsageDescription和NSLocationWhenInUseUsageDescription字段。
class _GDNavigationState extends State<GDNavigation> {
//  AMapController _controller;
//  MyLocationStyle _myLocationStyle = MyLocationStyle();
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(left: 10),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff00d7ee), Color(0xff00a7ff)]),
          ),
          child: SafeArea(
              child: Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 18,
                  ),
                  Text("导航", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              )),
        ),
        preferredSize: Size(double.infinity, 60),
      ),
      body: Column(
        children: <Widget>[
//          Container(
//            height: Adapt.px(900),
//            child: AMapView(
//              onAMapViewCreated: (controller) {
//                _controller = controller;
//                _subscription = _controller.markerClickedEvent
//                    .listen((it) => print('地圖點擊"：坐標：$it'));
////                點擊標註圖標執行
//                _controller.addMarker(MarkerOptions(
//                    icon: 'img/place.png',
//                    position: LatLng(widget.longitude, widget.latitude),
//                    title: '導航',
//                    snippet: '導航'));
//              },
//              amapOptions: AMapOptions(
//                compassEnabled: false,
//                zoomControlsEnabled: true,
//                logoPosition: LOGO_POSITION_BOTTOM_LEFT,
//                camera: CameraPosition(
//                  target: LatLng(widget.longitude, widget.latitude),
//                  zoom: 15,
//                ),
//              ),
//            ),
//          ),
//          BooleanSetting(
//            head: '顯示自己位置',
//            selected: false,
//            onSelected: (value) {
//              _updateMyLocationStyle(context,
//                  showMyLocation: value,
//                  radiusFillColor: Colors.black12);
//            },
//          ),
//          Container(
//            height: 100,
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                  flex: 1,
//                  child: IconButton(icon:Icon(Icons.directions_walk),onPressed:() {
//                    AMapNavi().startNavi(
//                        lat: widget.longitude,
//                        lon: widget.latitude,
//                        naviType: AMapNavi.walk);
//                  },iconSize: 45,color: Colors.lightBlueAccent),
//                ),
//                Expanded(
//                  flex: 1,
//                  child: IconButton(icon: Icon(Icons.directions_bike),onPressed: () {
//                    AMapNavi().startNavi(
//                        lat: widget.longitude,
//                        lon: widget.latitude,
//                        naviType: AMapNavi.ride);
//                  },iconSize: 45,color: Colors.lightBlueAccent),
//                ),
//                Expanded(
//                  flex: 1,
//                  child: IconButton(icon: Icon(Icons.drive_eta),onPressed: () {
//                    AMapNavi().startNavi(
//                        lat: widget.longitude,
//                        lon: widget.latitude,
//                        naviType: AMapNavi.drive);
//                  },iconSize: 45,color: Colors.lightBlueAccent,),
//                ),
//              ],
//            ),
//          ),
        ],
      ),
    );
  }

//  //region 权限申请
//  void _updateMyLocationStyle(
//    BuildContext context, {
//    String myLocationIcon,
//    double anchorU,
//    double anchorV,
//    Color radiusFillColor,
//    Color strokeColor,
//    double strokeWidth,
//    int myLocationType,
//    int interval,
//    bool showMyLocation,
//    bool showsAccuracyRing,
//    bool showsHeadingIndicator,
//    Color locationDotBgColor,
//    Color locationDotFillColor,
//    bool enablePulseAnnimation,
//    String image,
//  }) async {
//    if (await Permissions().requestPermission()) {
//      _myLocationStyle = _myLocationStyle.copyWith(
//        myLocationIcon: myLocationIcon,
//        anchorU: anchorU,
//        anchorV: anchorV,
//        radiusFillColor: radiusFillColor,
//        strokeColor: strokeColor,
//        strokeWidth: strokeWidth,
//        myLocationType: myLocationType,
//        interval: interval,
//        showMyLocation: showMyLocation,
//        showsAccuracyRing: showsAccuracyRing,
//        showsHeadingIndicator: showsHeadingIndicator,
//        locationDotBgColor: locationDotBgColor,
//        locationDotFillColor: locationDotFillColor,
//        enablePulseAnnimation: enablePulseAnnimation,
//      );
//      _controller.setMyLocationStyle(_myLocationStyle);
//    } else {
//      //ToastUtils.showToast( '权限不足');
//    }
//  }
//
////endregion

  //region 销毁事件
  @override
  void dispose() {
//    _controller?.dispose();
    _subscription?.cancel();
    super.dispose();
  }
//endregion

}
