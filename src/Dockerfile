FROM node:16-alpine
WORKDIR /app
COPY package* .
RUN npm install
copy . .
EXPOSE 3000
CMD ["npm","run","dev"]