# Dart Frog Todo - Aplicação "TODO" simples com API e interface web

Uma aplicação simples de lista da tarefas, feita com [dart_frog](https://dartfrog.vgv.dev/). Pode ser usada como uma API ou como uma aplicação web completa.

## Recursos

- 🌐 **Aplicação WEB com Jinja**: Interface web simples.  
- 📄 **API JSON**: API REST para interagir com JSON.  
- 🛠️ **Fonte de dados em memória**: Sem necessidade de um banco de dados para prototipação rápida.
- 🛠️ **Fonte de dados Postgres**: Conexão com banco Postgres.
- ✅ **Testes**: Garante qualdiade contínua com testes.  
- 📚 **Documentação com Swagger**: Navegação simples e interativa para a API. 



## Stack

- **CSS & HTML**: Para estilos e estruturação.  
- **Jinja**: Ferramenta de template para páginas web dinâmicas.  
- **Dart**: Principal linguagem.  
- **Dart Frog**: Framework para a API e códigos de servidor. 


## Rodar Localmente

Instale o cli `dart_frog_cli`

```bash
  dart pub global activate dart_frog_cli
```

Clone o projeto

```bash
  git clone https://github.com/CauaLW/dart_frog_todo
```

Vá até a pasta do projeto

```bash
  cd dart_frog_todo
```

Instale as dependencias

```bash
  dart pub get
```

Inicie o servidor

```bash
  dart_frog dev
```

No seu navegador:

- Aplicação web: http://localhost:8080
- Rotas da API: http://localhost:8080/api
- Documentação da API: http://localhost:8080/documentation.html


## Rodando os testes

Para rodar os testes, basta executar:

```bash
  dart test
```


## Usando Postgres
Para rodar usando um banco de dados Postgres, crie e preencha um arquivo `.env` copiando os dados de `.env.example`, e altere `USE_POSTGRES` para `true`:
```bash
  DB_HOST=
  DB_NAME=
  DB_USER=
  DB_PASSWORD=
  USE_POSTGRES=true
```