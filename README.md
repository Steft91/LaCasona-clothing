# La Casona

App Flutter de e-commerce de ropa con estética colonial quiteña.

## Configuración local

1. Copia `.env.example` como `.env` y coloca tu clave de Gemini:

```bash
cp .env.example .env
```

2. Agrega tu archivo Firebase Android en:

```bash
android/app/google-services.json
```

3. Instala dependencias:

```bash
flutter pub get
```

4. Ejecuta en Android:

```bash
flutter run
```

## Validación

```bash
flutter analyze
flutter test
```
