## Quickstart

I'm not enrolled in Apple's Developer program (too broke) so I cannot create an .IPA file.
You can run this project by opening it in Xcode and selecting Product > Run. Requires iOS 27.2 or above.

The example API is a standard Flask API is run using the following command:
```flask --app api run --host=0.0.0.0 --port <port>```

If using the example API, the endpoint constant in the file ```CalorieTracker/Model/BarcodeAPI``` must be changed to match the endpoint that your server is using. This will vary based on what network you are connected to.
