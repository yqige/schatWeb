class Controller{
  final String path;
//构造方法定义为编译时常量
  const Controller({this.path});
  @override
  String toString() =>'Controller';//这里是区别其它注解
}
