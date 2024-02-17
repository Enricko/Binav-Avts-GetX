class General{
  static bool isApiOk(int status){
    if(status >= 200 && status < 300){
      return true;
    }
    return false;
  }
}