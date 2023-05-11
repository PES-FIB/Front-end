
class userApis {


static String _LoginUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/login';
static String _RegisterUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/register';
static String _logOutUrl = 'http://nattech.fib.upc.edu:40331/api/v1/auth/logout';
static String _showMeUrl = 'http://nattech.fib.upc.edu:40331/api/v1/users/showMe';
static String _updateUserurl = 'http://nattech.fib.upc.edu:40331/api/v1/users/updateUser';
static String _updateUserPassword = 'http://nattech.fib.upc.edu:40331/api/v1/users/updateUserPassword';
static String _exportCalendarurl = 'http://nattech.fib.upc.edu:40331/api/v1/users/exportCalendar';
static String _deleteUserUrl = 'http://nattech.fib.upc.edu:40331/api/v1/users/deleteUser';

static String getLoginUrl() {return _LoginUrl;}
static String getRegisterUrl() {return _RegisterUrl;}
static String getLogoutUrl() {return _logOutUrl;}
static String getshowMe() {return _showMeUrl;}
static String getupdateUser() {return _updateUserurl;}
static String getupdatePassword() {return _updateUserPassword;}
static String getExportCalendar() {return _exportCalendarurl;}
static String getDeleteUser() {return _deleteUserUrl;}

}
