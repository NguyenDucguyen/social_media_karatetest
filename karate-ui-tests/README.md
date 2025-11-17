Karate UI tests (UI-only)

This folder contains a minimal Karate project that runs a small UI smoke test against the React frontend.

Prerequisites
- Java 17+ (matches your backend environment)
- Maven
- The React frontend must be running at `http://localhost:3000` (run `npm start` in the `client` folder)

Run the test
1. Start the frontend: open a terminal and run:

```cmd
cd client
npm start
```

2. In a separate terminal, run the Karate tests:

```cmd
cd karate-ui-tests
mvn test
```

Notes
- The feature `src/test/java/ui/ui.feature` uses Chrome in headless mode. To see the browser during test runs, edit the `configure driver` line and set `headless: false`.
- The test is UI-only: it navigates to the login page and asserts the presence of the email/password inputs and page title.
- If your frontend runs on a different port, update the URL in `ui.feature`.
