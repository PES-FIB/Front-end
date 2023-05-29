class ReportApis {
  static String reportReview = 'http://nattech.fib.upc.edu:40331/api/v1/report/reportReview/:reviewId';
  static String reportEvent = 'http://nattech.fib.upc.edu:40331/api/v1/report/reportReview/:eventId';
  static String getReportReviewUrl(int reviewId) {return reportReview.replaceAll(':reviewId', reviewId.toString());}
  static String getReportEventUrl(int eventId) {return reportEvent.replaceAll(':eventId', eventId.toString());}
}