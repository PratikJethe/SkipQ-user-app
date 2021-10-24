class SuccessResponse {
  bool error;
  int code;
  dynamic data;

  SuccessResponse(this.error, this.code, this.data);
}

class FailedResponse {
  bool error;
  int code;
  String errMsg;
  FailedResponse(this.error, this.code, this.errMsg);
}

class ApiResponse {
   bool error;
   int statusCode;
   String errMsg;
   dynamic data;
 
  ApiResponse(this.statusCode, this.data, this.errMsg, this.error);
}
