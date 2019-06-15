import 'dart:io';

import 'retention/controller.dart';
import 'retention/request.dart';
import 'utils/baseController.dart';

@Controller(path: '/user')
class UserController extends BaseController{
  @Get(path: '/login')
  void login(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln('LoginSuccess')
      ..close();
  }

  @Post(path: '/logout')
  void logout(HttpRequest request){
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln('logoutSuccess')
      ..close();
  }

  @Request(path: '/delete', method: 'DELETE')
  void editUser(HttpRequest request){
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln('DeleteSuccess')
      ..close();
  }
}
