class ResponseException  implements Exception{
  int code;
  String message;
  ResponseException({required this.code,required this.message});

  @override
  String toString() {
    // TODO: implement toString
    return '[$code] $message';
  }

}