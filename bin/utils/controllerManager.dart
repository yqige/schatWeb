import 'dart:mirrors';
import 'dart:io';

import 'baseController.dart';
import 'controllerInfo.dart';
class ControllerManager{
  static ControllerManager manager=new ControllerManager();

//该list用于判断Controller是否已经被添加
  List<BaseController> controllers=[];
//这是一个map，对应的是请求链接，跟对应的controller信息
  Map<String,ControllerInfo> urlToMirror=new Map();

  //添加控制器
  void addController(BaseController controller){
//判断当前是否已经添加过控制器
    if(!controllers.contains(controller)){
      controllers.add(controller);
//添加map
      urlToMirror.addAll(getRequestInfo(controller));
    }
  }

//该controllerManager处理请求的方法
  void requestServer(HttpRequest request){
    //当前请求的路径
    String path=request.uri.toString();
    //当前请求的方法
    String method=request.method;

    //判断map中是否包含该请求地址
    if(urlToMirror.containsKey(path)){
      ControllerInfo info=urlToMirror[path];
//获取到该请求，传递路径、请求方法跟请求
      info.invoke(path, method, request);
    }else{
//没有该地址返回一个404
      request.response
        ..statusCode=HttpStatus.notFound
        ..write('''{
    "code": 404,
    "msg": "链接不存在！"
}''')
        ..close();
    }
  }

  //传递一个Controller进去
  Map<String,ControllerInfo> getRequestInfo(BaseController controller) {
// 实际返回的Map
    Map<String,ControllerInfo> info=new Map();
//请求地址对应的方法
    Map<String,Symbol> urlToMethod=new Map();
// 获取Controller实例的镜子
    InstanceMirror im = reflect(controller);
//获取Controller运行时类型的镜子
    ClassMirror classMirror = im.type;
//请求的根路径
    List<String> path = [];
//该Controller的所有接收的请求地址
    List<String> urlList=[];

//获取元数据,就是获取@Controller(path: xxx)中的xxx
    classMirror.metadata.forEach((medate) {
      path.add(medate.reflectee.path);
    });

    //获取该类的所有方法
    classMirror.declarations.forEach((symbol, declarationMirror) {
      //将自身的构造方法剔除
      if (symbol.toString() != classMirror.simpleName.toString()) {
        //获取方法的元数据，就是@Get(path： path)
        declarationMirror.metadata.forEach((medate) {
          //请求的地址
          String requestPath = path.join() + medate.reflectee.path;
          //请求的类型
          String method = medate.reflectee.method;

//        print('请求地址为：$requestPath,请求方法为：$method');
          //添加到请求地址集合
          urlList.add(requestPath);
//添加到请求地址对应方法的集合
          urlToMethod.putIfAbsent('$requestPath#$method', ()=>symbol);
        }
        );
      }
    });

//实例化一个Controller信息
    ControllerInfo controllerInfo=new ControllerInfo(im, urlToMethod);

//循环添加到实际需要的Map，对应请求地址根ControllerInfo信息
    urlList.forEach((url){
      info.putIfAbsent(url, ()=>controllerInfo);
    });
//返回需要的map
    return info;
  }
}
