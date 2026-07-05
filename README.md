# La Casona

App Flutter de e-commerce de ropa con estética colonial quiteña.

## Configuracion local

1. Agrega tu archivo Firebase Android en:

```bash
android/app/google-services.json
```

2. Instala dependencias:

```bash
flutter pub get
```

3. Configura los secretos del backend:

```bash
firebase functions:secrets:set STRIPE_SECRET_KEY
firebase functions:secrets:set SENDGRID_API_KEY
firebase functions:secrets:set GEMINI_API_KEY
```

4. Configura los valores no secretos de Functions:

```bash
cp functions/.env.example functions/.env
```

5. Instala dependencias y despliega Functions:

```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

6. Ejecuta en Android:

```bash
flutter run
```

Las claves privadas de Stripe, SendGrid y Gemini no deben ir en `.env` ni como
assets de Flutter. La app llama a Firebase Functions para checkout demo, correo
y Casona AI.

## Validación

```bash
flutter analyze
flutter test
```
