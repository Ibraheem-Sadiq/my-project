FROM node:14-alpine 
WORKDIR /App
COPY package*.json ./

COPY . .
EXPOSE 3000
RUN npm install 
RUN npm run build
CMD ["npm","start"]
# FROM node:14-alpine
# WORKDIR /App
# COPY package*.json ./
# RUN npm install cors
# RUN npm install

# COPY . .
# 

# EXPOSE 3000

# CMD ["node", "index.js"]