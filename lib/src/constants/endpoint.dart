const String baseUrl = 'https://parseapi.back4app.com/functions';
//const String baseUrl =
//  'https://terrier-equipped-supposedly.ngrok-free.app/parse/functions';
//const String baseUrl = 'http://localhost:1337/parse/functions';

abstract class Endpoints {
  static const String perfil = '$baseUrl/perfil';
  static const String signin = '$baseUrl/login';
  static const String signup = '$baseUrl/signup';
  static const String validateToken = '$baseUrl/validate-token';
  static const String resetPassword = '$baseUrl/reset-password';
  static const String getAllCategories = '$baseUrl/get-category-list';
  static const String getAllProducts = '$baseUrl/get-product-list';
  static const String getAllChapters = '$baseUrl/get-chapter-list';
  static const String getAllPages = '$baseUrl/get-pages-list';
  static const String getFavoritesItems = '$baseUrl/get-favorite-items';
  static const String addItemToFavorites = '$baseUrl/add-item-to-favorites';
  static const String removeItemToFavorites = '$baseUrl/unfavorite-item';
  static const String changPassword = '$baseUrl/change-password';
  static const String getPublishersItems = '$baseUrl/get-publish-items';
  static const String publishCape = '$baseUrl/publish-cape-story';
  static const String publishChapter = '$baseUrl/publish-cape-chapter';
  static const String publishPages = '$baseUrl/publish-pages-chapter';
  static const String editeCoverStory = '$baseUrl/edite-cover-story';
  static const String editeChapterStory = '$baseUrl/edite-chapter-story';
  static const String getCartCoins = '$baseUrl/get-cart-coins';
  static const String getAllCoins = '$baseUrl/get-coin-list';
  static const String addCoinToCart = '$baseUrl/add-coin-to-cart';
  static const String changeCoinQuantity = '$baseUrl/modify-coin-quantity';
  static const String checkout = '$baseUrl/checkout';
  static const String getAllOrders = '$baseUrl/get-orders';
  static const String getOrderItems = '$baseUrl/get-orders-coins';
  static const String editePage = '$baseUrl/edite-pages-chapter';
  static const String getCoinsOfUser = '$baseUrl/get-coins-of-user';
  static const String getFavoriteCount = '$baseUrl/get-favorite-count';
  static const String getAllFavoritesItems = '$baseUrl/get-all-favorite-items';
  static const String getChapterCount = '$baseUrl/get-chapters-count';
  static const String getPageCount = '$baseUrl/get-pages-count';
  static const String getAllGallery = '$baseUrl/get-Gallery-list';
  static const String getAllGalleryChapter =
      '$baseUrl/get-Gallery-Chapter-list';
  static const String addPageCount = '$baseUrl/add-page-count';
  static const String deleteChapter = '$baseUrl/delete-chapter';
  static const String deleteStory = '$baseUrl/delete-story';
  static const String deletePage = '$baseUrl/delete-page';
}
