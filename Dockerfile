FROM node:19-alpine3.15
WORKDIR /app
COPY . package*
RUN npm install
copy . .
EXPOSE 3000
CMD ["npm","run","dev"]