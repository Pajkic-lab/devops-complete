FROM node:alpine as react_build 
WORKDIR /app
COPY . /app/ 
RUN npm install 
RUN npm run build 

FROM nginx:alpine

COPY --from=react_build /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

EXPOSE 80 
CMD ["nginx","-g","daemon off;"]

#docker build -t reactapp .
#docker run -p 3000:80 reactapp