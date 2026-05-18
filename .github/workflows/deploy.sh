name: Deploy React App

on:
  push:
    branches:
      - main  # Oder 'master', je nachdem wie dein Haupt-Branch heißt

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Install Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install Dependencies & Build
        run: |
          npm install
          npm run build

      - name: Deploy to vServer via rsync
        uses: AEnterprise/rsync-deploy@v1.0.2
        env:
          DEPLOY_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
          ARGS: "-avz --delete"
          SERVER_PORT: "22"
          FOLDER: "dist/"  # Der Ordner, den Vite generiert
          SERVER_IP: ${{ secrets.SERVER_IP }}
          USERNAME: ${{ secrets.SERVER_USER }}
          SERVER_DESTINATION: "/var/projects/delyx.samwilliam.de/"