# Dart Frog Todo - A Simple Todo App with API and Web Interface

A lightweight todo app built with [dart_frog](https://dartfrog.vgv.dev/). Use it as an API backend or a full-featured web application.

## Features

- 🌐 **Web application with Jinja template**: A clean and simple web interface.  
- 📄 **JSON API**: RESTful API for programmatic interactions.  
- 🛠️ **In-memory datasource**: No database setup needed for quick prototyping.  
- 🛠️ **Postgres datasource**: Postgres database connection if desired.
- ✅ **Testing**: Ensure reliability with prebuilt tests.  
- 📚 **Swagger documentation**: Easy-to-navigate API docs. 



## Tech Stack

- **CSS & HTML**: For styling and structure.  
- **Jinja**: Templating engine for rendering dynamic web pages.  
- **Dart**: Core language for the app.  
- **Dart Frog**: Framework for building APIs and server-side logic. 


## Run Locally

Install `dart_frog_cli`

```bash
  dart pub global activate dart_frog_cli
```

Clone the project

```bash
  git clone https://github.com/CauaLW/dart_frog_todo
```

Go to the project directory

```bash
  cd dart_frog_todo
```

Install dependencies

```bash
  dart pub get
```

Start the server

```bash
  dart_frog dev
```

Open your browser:

- Web app: http://localhost:8080
- API routes: http://localhost:8080/api
- API documentation: http://localhost:8080/documentation.html


## Running Tests

To run tests, run the following command

```bash
  dart test
```


## Using Postgres
If you want to use a Postgres database, create and fill a `.env` copying from `.env.example`, and set `USE_POSTGRES` to `true`:
```bash
  DB_HOST=
  DB_NAME=
  DB_USER=
  DB_PASSWORD=
  USE_POSTGRES=true
```