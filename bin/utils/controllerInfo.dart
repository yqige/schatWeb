import 'dart:io';
import 'dart:mirrors';

class ControllerInfo{
//请求地址对应Controller中的方法，Symbol包含方法标识
  final Map<String,Symbol> urlToMethod;
//该参数包含通过类初始化得到的实例镜子，可以通过该参数调用方法
  final InstanceMirror instanceMirror;

//构造方法
  ControllerInfo(this.instanceMirror,this.urlToMethod);

  //调用请求方法
  void invoke(String url,String method,HttpRequest request){
    //判断是否该请求地址是对应的请求方法
    if(urlToMethod.containsKey('$url#$method')){
//调用方法
      instanceMirror.invoke(urlToMethod['$url#$method'], [request]);
    }else {
//请求方法不对，返回一个错误
      request.response
        ..statusCode=HttpStatus.methodNotAllowed
        ..write('''{
    "code": 405,
    "msg": "请求出错！"
}''')
        ..close();
    }
  }
}
