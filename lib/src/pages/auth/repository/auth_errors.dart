String authErrorString(String? code) {
  switch (code) {
    case 'INVALID_CREDENTIALS':
      return 'Email e/ou senha invalidos';
    case 'Invalid session token':
      return 'Token invalido';
    case 'INVALID_FULLNAME':
      return 'Ocorreu um erro ao se cadastrar:nome invaliso ';
    case 'INVALID_PHONE':
      return 'Ocorreu um erro ao se cadastrar:celular invalido ';
    case 'INVALID_CPF':
      return 'Ocorreu um erro ao se cadastrar: cpf invalido';
    case 'INVALID_USER':
      return 'Editor não emcontrado';
    default:
      return 'Um erro indefinido ocorreu!';
  }
}
