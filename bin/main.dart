import 'package:http_server/http_server.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'userController.dart';
import 'utils/controllerManager.dart';
import 'utils/logUtils.dart';

main() async {
  // todo 自动扫描
  ControllerManager.manager.addController(new UserController());
  var webPath=dirname(dirname(Platform.script.toFilePath()))+'/webapps';
  VirtualDirectory staticFiles=new VirtualDirectory(webPath);
  //允许目录监听,按照目录去请求
  staticFiles.allowDirectoryListing=true;
//目录处理，当请求根目录时，会返回该地址
  staticFiles.directoryHandler=(dir,request){
    var indexUri=new Uri.file(dir.path,).resolve('index.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };
  staticFiles.errorPageHandler=(request){
    if(request.uri.pathSegments.last.contains('.html')){
      staticFiles.serveFile(new File(webPath+'/404.html'), request);
    }else{
      ControllerManager.manager.requestServer(request);
    }
  };
  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv6, 8080);
  print('监听 localhost地址，端口号为${requestServer.port}');
  LogUtils.log.finest('服务器启动：http://localhost:${requestServer.port}');
  await requestServer.forEach((request) {
    staticFiles.serveRequest(request);
  });
}
