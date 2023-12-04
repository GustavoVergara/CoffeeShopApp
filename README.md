# Projeto Integrador Transdiciplinar 2 - Cruzeiro do Sul

Esse app foi feito como parte do meu trabalho final do meu Bacharelado em Ciência da Computação na Cruzeiro do Sul.

É um aplicativo nativo para iOS, fortemente inspirado pelo UberEats e o aplicativo do Starbucks.

Nesse repositório você encontra:
- O código nativo para iOS, majoritariamente escrito em Swift, usando SwiftUI para as telas.
- O código do servidor, escrito em Javascript com Node.js e express.

## Executando o código
Para executar o código primeiro você precisa iniciar o servido, para isso você precisa ter `node` instalado na sua maquina.
- Na linha de comando, navegue até a pasta `/server/`
- Execute `node app.js`

Quando o servidor estiver rodando você já pode executar o aplicativo.
Para isso você vai precisar estar usando o macOS Monterey ou superior (`12.6.9+`) e ter o Xcode 14.2 ou superior.
- Abra o arquivo `ios/CoffeeShop.xcworkspace`
- Espere os pacotes serem sincronizados
- Rode o `CoffeeApp`