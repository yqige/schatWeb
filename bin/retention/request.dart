class Request{
  final String path;
  final String method;

  const Request({this.path,this.method});

  @override
  String toString() =>'Request';
}
class Get extends Request{
  final String path;

  const Get({this.path}) : super(path : path,method: 'GET');

  @override
  String toString() =>'Get';
}

class Post extends Request{
  final String path;

  const Post({this.path}) : super(path : path, method: 'POST');

  @override
  String toString() =>'POST';

}
