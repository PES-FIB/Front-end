
class userApis {
static String _LoginUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/login';
static String _RegisterUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/register';
static String _logOutUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/logout';
static String _showMeUrl = 'http://nattech.fib.upc.edu:40331/api/v1/users/showMe';
static String _updateUserurl = 'http://nattech.fib.upc.edu:40331/api/v1/users/updateUser';
static String _updateUserPassword = 'http://nattech.fib.upc.edu:40331/api/v1/users/updateUserPassword';
static String _SignInGoogleUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/googleSignIn';
static String _SignInGoogleCollbackUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/google/callback';
static String _getUserUrl = 'http://nattech.fib.upc.edu:40331/api/v1/users/:id';

static String getLoginUrl() {return _LoginUrl;}
static String getRegisterUrl() {return _RegisterUrl;}
static String getLogoutUrl() {return _logOutUrl;}
static String getshowMe() {return _showMeUrl;}
static String getupdateUser() {return _updateUserurl;}
static String getupdatePassword() {return _updateUserPassword;}
static String getSignInGoogle() {return _SignInGoogleUrl;}
static String getSignInGoogleCollback() {return _SignInGoogleCollbackUrl;}
static String getUser(int userId) {return _getUserUrl.replaceAll(':id', userId.toString());}
}
