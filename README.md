Minhas Séries - Gerenciador de Séries de TV

Este é um projeto de aplicativo mobile desenvolvido como trabalho final para a disciplina de Mobile I. O objetivo é criar um gerenciador completo onde os usuários podem buscar, salvar, organizar e avaliar as séries de TV que assistem.


✨ Funcionalidades Principais

    Autenticação de Usuários: Sistema completo de Login e Registro. Cada usuário possui suas próprias listas e avaliações, que são salvas de forma independente.

    Busca de Séries: Consumo da API do The Movie Database (TMDb) para buscar séries em tempo real pelo nome.

    Detalhes da Série: Visualização de informações completas como sinopse, pôster e outras informações relevantes obtidas da API.

    Listas Pessoais: O usuário pode salvar séries em três categorias distintas: "Assistindo", "Quero Ver" e "Já Vi".

    Avaliação e Comentários: Funcionalidade para atribuir uma nota pessoal (de 1 a 5 estrelas) e adicionar comentários de texto a cada série salva na sua lista.

    Gerenciamento Completo (CRUD): O usuário pode Adicionar, Ler, Atualizar (mudar status, nota ou comentário) e Deletar séries de suas listas a qualquer momento.

    Persistência de Dados: Uso de um banco de dados local SQLite para armazenar de forma segura todas as informações dos usuários, suas listas, notas e comentários.

🚀 Tecnologias Utilizadas

    Framework: Flutter

    Linguagem: Dart

    Banco de Dados: SQLite, gerenciado com o pacote sqflite.

    Consumo de API: Pacote http para requisições à API REST do The Movie Database (TMDb).

    Gerenciamento de Estado: Utilização de StatefulWidget e o método setState para gerenciar o estado das telas de forma reativa.

    Arquitetura: O projeto foi estruturado com separação de responsabilidades, utilizando:

        Uma classe DatabaseHelper para centralizar toda a lógica do banco de dados.

        Widgets customizados e reutilizáveis (como o SerieCard) para manter o código da interface limpo e organizado (fatoração de código).

        Estrutura de pastas para telas (screens), widgets e lógica de dados (bd).

⚙️ Configuração do Projeto

Para rodar este projeto localmente, é necessário configurar a chave de acesso à API do TMDb.

    Na pasta lib/, crie um arquivo chamado secrets.dart.

    Dentro deste arquivo, cole o seguinte código:

    const String tmdbApiKey = "SUA_CHAVE_DA_API_TMDB_AQUI";

    Obtenha sua própria chave de API v4 (Bearer Token) gratuitamente no site do TMDb.

    Substitua o texto "SUA_CHAVE_DA_API_TMDB_AQUI" pela sua chave.

Após configurar a chave, instale as dependências e rode o projeto:

flutter pub get
flutter run
