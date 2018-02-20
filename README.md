# Search Movies

Com Search Movies, através da api The Movie DB, o usuário poderá buscar filmes, favoritá-los e assistir aos trailers. É possível a visualização dos filmes em formato de grid ou de lista. Nos detalhes do filme consta o poster filme, o nome, a sinopse e os trailers (caso exista). É possível favoritar o filme na tela de detalhes.

## Imagens
![Search](https://github.com/nmacambira/SearchMovies/blob/master/Images/Search.png)   ![Detail](https://github.com/nmacambira/SearchMovies/blob/master/Images/Detail.png)   ![Feature](https://github.com/nmacambira/SearchMovies/blob/master/Images/Feature.png)

## Especificações Técnicas

- iOS 10.0 +
- Swift 4
- iPhone
 
## Arquitetura

Foi utilizado como arquitetura o MVC por questões de familiariedade.

## Bibliotecas de terceiros

- [Realm](https://realm.io/docs/swift/latest)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
- [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
- [ObjectMapper-Realm](https://github.com/Jakenberg/ObjectMapper-Realm)
- [Kingfisher](https://github.com/onevcat/Kingfisher)

## O que pode ser melhorado

- Permitir favoritar filmes nas collecitionview/tableview;
- Criar funcionalidade de ampliar poster;
- Mostrar poster de fundo quando na posiçao landscape;
- Refatoraçao de código: criar request genéricos, remover metodos na view desnecessários, remover códigos repetidos, alterar cor de fundo do app.

## Requisitos obrigatórios

Acredito que todos os requisitos obrigatórios foram entregues.

## License

[MIT License](https://github.com/nmacambira/SearchMovies/blob/master/LICENSE)

