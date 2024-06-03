String followErrorString(String? code) {
  switch (code) {
    case 'EDITOR_ALREADY_FOLLOWED':
      return 'voce ja esta seguindo este editor';
    case 'INVALID-EDITOR':
      return 'editor inexistente';
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
