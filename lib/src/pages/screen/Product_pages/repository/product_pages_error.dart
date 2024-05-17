String pagesErrorString(String? code) {
  switch (code) {
    case 'COIN_TO_USER_NOT_FOUND':
      return 'É preciso comprar moedas para essa ação!';
    case 'QUANTITY_EXCEEDS_TOTAL':
      return 'Voce não tem moedas o suficiente para esta ação!';
    default:
      return 'Um erro indefinido ocorreu!';
  }
}
