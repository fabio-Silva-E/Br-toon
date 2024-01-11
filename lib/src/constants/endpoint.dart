const String baseurl = 'https://parseapi.back4app.com/functions';

abstract class Endpoints {
  static const String signin = '$baseurl/login';
  static const String signup = '$baseurl/signup';
  static const String validateToken = '$baseurl/validate-token';
  static const String resetPassword = '$baseurl/reset-password';
  static const String getAllCategories = '$baseurl/get-category-list';
  static const String getAllProducts = '$baseurl/get-product-list';
  static const String getAllChapters = '$baseurl/get-chapter-list';
  static const String getAllPages = '$baseurl/get-pages-list';
  static const String getFavoritesItems = '$baseurl/get-favorite-items';
  static const String addItemToFavorites = '$baseurl/add-item-to-favorites';
  static const String removeItemToFavorites = '$baseurl/unfavorite-item';
  static const String changPassword = '$baseurl/change-password';
  static const String getPublishersItems = '$baseurl/get-publish-items';
  static const String publishCape = '$baseurl/publish-cape-story';
  static const String publishChapter = '$baseurl/publish-cape-chapter';
  static const String publishPages = '$baseurl/publish-pages-chapter';
  static const String modifyCoverStory = '$baseurl/modify-cover-story';
}
