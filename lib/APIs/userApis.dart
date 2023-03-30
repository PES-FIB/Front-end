
class userApis {


static String _LoginUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/login';
static String _RegisterUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/register';
static String _logOutUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/logout';
static String _showMeUrl = 'http://nattech.fib.upc.edu:40331/api/v1/users/showMe';

static String getLoginUrl() {return _LoginUrl;}
static String getRegisterUrl() {return _RegisterUrl;}
static String getLogoutUrl() {return _logOutUrl;}
static String getshowMe() {return _showMeUrl;}

}
