
# Milka

**Milka** is a digital music search application. It implements simple UI with searching capability of albums and artists. The albums search results are displayed as grid list while the artists are showed as list tiles.
The application is configured with ***BLOC*** pattern accesing remote Spotify Web API data with ***DIO***.


## Getting started

Clone the project

```bash
  git clone https://github.com/jotelij/milka
```

Go to the project directory

```bash
  cd milka
```

Install dependencies

```bash
  flutter pub get
```

Run the app. It has been tested on android device.
```bash
  flutter pub run build_runner build
```

```bash
  flutter run
```

## Running Tests

The test folder contains unit tests for almost all components. Before running test you have to build the mocks. To run tests, run the following command

```bash
  flutter pub run build_runner build
```

```bash
  flutter test
```


## Roadmap

- Introducing a new **AppTheme** [core/app_theme.dart] class with light and dark theme toggle functionality. 

- Adding a local cache storage for search results by adding a new cache inteceptor, using ***dio_cache_interceptor*** plugin, on the ***Dio*** instance of **Repository** [app/data/repository.dart] class. 

- Adding a secure access token storing method on the **Repository** [app/data/repository.dart] class.

- Spotify private keys are hardcoded in the **AppConstat** [core/app_constants.dart] class in core folder. Since we are doing Client Credentials type of authentication, it will be exposing the secret key. Also, this approach is only recommend for server side(backend) applications authentication. To tackle this 
  - The authentication approach can be changed to Authorization code with PKCE, as recommended with Spotify. And client side code can be achieved by introducing a new repository **AuthenticationRepository** which utilizes **OAuth2** features.
  - Using on build enviroment variable injection which can be then securelty saved in the app with *flutter_secure_storage* extention. Then the storage can be accessed from the **Repository** single instance constructor
  - 


## Authors

- [@jotelij](https://www.github.com/jotelij)


## 🚀 About Me
I'm a self-taught full stack developer.

- Name: Jote Gutema
- Email: jotelij@outlook.com/jtljlm3@gmail.com


## License

[MIT](https://choosealicense.com/licenses/mit/)
