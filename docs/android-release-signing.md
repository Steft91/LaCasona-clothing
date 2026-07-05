# Android release signing

This project signs release App Bundles with a local upload key.

Local files required for release builds:

- `android/key.properties`
- `android/app/upload-keystore.jks`

Both files are intentionally ignored by Git because they contain private signing
credentials. Back them up in a safe place before uploading the first production
or internal testing release to Play Console.

Build command:

```bash
flutter build appbundle
```

Output:

```bash
build/app/outputs/bundle/release/app-release.aab
```

Verification:

```bash
jarsigner -verify build/app/outputs/bundle/release/app-release.aab
```

Expected result includes `jar verified`.
