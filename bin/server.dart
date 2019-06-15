import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln(
        'Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_echoRequest);

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

shelf.Response _echoRequest(shelf.Request request) {
  dynamic body = _handleMessage(request);
  return shelf.Response.ok('Request for "${body}"');
}
dynamic _handleMessage(shelf.Request request){
  request.headers.forEach((key,values){
    print('key:$key');
//    for(String value in values){
      print('value:$values');
//    }
  });
  dynamic res;
  try{
    if(request.method=='GET'){
      //获取到GET请求
      res = _handleGET(request);
    }else if(request.method=='POST'){
      //获取到POST请求
      res = _handlePOST(request);
    }else{
      //其它的请求方法暂时不支持，回复它一个状态
      res = '对不起，不支持${request.method}方法的请求！';
    }
  }catch(e){
    print('出现了一个异常，异常为：$e');
  }
  print('请求被处理了');
  return res;
}

dynamic _handleGET(shelf.Request request){
  //处理GET请求
  return request.url.queryParameters['id'];
}
dynamic _handlePOST(shelf.Request request){
  //处理POST请求
}
