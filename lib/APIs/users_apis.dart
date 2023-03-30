// ignore_for_file: non_constant_identifier_names
class UserApis {

static String _LoginUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/login';
static String _RegisterUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/register';
static String _LogoutUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/logout';


static String getLoginUrl() {return _LoginUrl;}
static String getRegisterUrl() {return _RegisterUrl;}
static String getLogoutUrl() {return _LogoutUrl;}
}