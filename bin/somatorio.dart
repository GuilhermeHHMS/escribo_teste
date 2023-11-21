import 'dart:io';

void main() {
  bool finished = false;

  print(
      'TESTE TÉCNICO ESCRIBO #1\nSomatório de números inteiros divisíveis por 3 e por 5.');

  while (finished != true) {
    print('Insira um número inteiro: ');

    String? inputData = stdin.readLineSync();
    int sum = 0;

    int? convertedData = int.tryParse(inputData!);

    if (convertedData != null) {
      sum = sumInteger(convertedData);

      print(
          'O resultado da soma interna de todos os números divisíveis por 3 e por 5 é: $sum');
      print('\n Deseja continuar? [S/N]');

      String? restart = stdin.readLineSync();

      if (restart != null && restart.toLowerCase() == 'n') {
        print('\nPressione \'Enter\' para finalizar...');

        String? closeApp = stdin.readLineSync();
        break;
      }
    } else {
      print('Nenhum valor válido inserido\n\n');
    }
  }
}

int sumInteger(int input) {
  
  int sumResult = 0;

  for (int i = 0; i < input; i++) {
    if (i % 3 == 0 || i % 5 == 0) {
      sumResult += i;
    }
  }
  return sumResult;
}
