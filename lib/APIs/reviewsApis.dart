class reviewApi {
static String getAllReviewsUrl = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/:eventId/getEventReviews';
static String createReviewUrl = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/:eventId/createReview';
static String deleteReview = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/deleteReview/:EventId';
static String updateReview = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/updateReview/:EventId';
static String reportReview = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/reportReview/:reviewId';
static String userReviewsUrl = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/getUserReviews';

static String getReviewsUrl(String eventId) {return getAllReviewsUrl.replaceAll(':eventId', eventId);}
static String getCreateReviewUrl(String eventId) {return createReviewUrl.replaceAll(':eventId', eventId);}
static String getDeleteReviewUrl(String eventId) {return deleteReview.replaceAll(':EventId', eventId);}
static String getUpdateReviewUrl(String eventId) {return updateReview.replaceAll(':EventId', eventId);}
static String getReportReviewUrl(int reviewId) {return reportReview.replaceAll(':reviewId', reviewId.toString());}
static String getUserReviewsUrl() {return userReviewsUrl;}


}