class reviewApi {
static String getAllReviewsUrl = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/:eventId';
static String createReviewUrl = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/:eventId/createReview';
static String deleteReview = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/deleteReview/:reviewId';
static String updateReview = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/updateReview/:reviewId';
static String reportReview = 'http://nattech.fib.upc.edu:40331/api/v1/reviews/reportReview/:reviewId';

static String getReviewsUrl(String eventId) {return getAllReviewsUrl.replaceAll(':eventId', eventId);}
static String getCreateReviewUrl(String eventId) {return createReviewUrl.replaceAll(':eventId', eventId);}
static String getDeleteReviewUrl(int reviewId) {return deleteReview.replaceAll(':reviewId', reviewId.toString());}
static String getUpdateReviewUrl(int reviewId) {return updateReview.replaceAll(':reviewId', reviewId.toString());}
static String getReportReviewUrl(int reviewId) {return reportReview.replaceAll(':reviewId', reviewId.toString());}

}